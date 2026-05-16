-- Pulse Database Schema
-- Run against a Supabase project

-- Profiles (extends Supabase auth.users)
create table if not exists public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  username text unique not null,
  avatar_color text default '#ff2d78',
  clout integer default 0,
  created_at timestamptz default now()
);

-- Scene drops (self-reports, 24h TTL)
create table if not exists public.sightings (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  username text not null,
  lat double precision not null,
  lng double precision not null,
  vibe text not null check (vibe in ('gym', 'alt', 'artsy', 'downtown', 'night-owl')),
  description text default '',
  verified boolean default false,
  clout integer default 0,
  created_at timestamptz default now(),
  expires_at timestamptz default (now() + interval '24 hours')
);

-- Indexes
create index if not exists idx_sightings_location on public.sightings (lat, lng);
create index if not exists idx_sightings_expires on public.sightings (expires_at);
create index if not exists idx_sightings_vibe on public.sightings (vibe);
create index if not exists idx_sightings_created on public.sightings (created_at desc);
create index if not exists idx_profiles_username on public.profiles (username);

-- RLS
alter table public.profiles enable row level security;
alter table public.sightings enable row level security;

-- Profiles: public read, self update
create policy "profiles_select" on public.profiles for select using (true);
create policy "profiles_insert" on public.profiles for insert with check (auth.uid() = id);
create policy "profiles_update" on public.profiles for update using (auth.uid() = id);

-- Sightings: public read (non-expired), auth insert, self delete
create policy "sightings_select" on public.sightings for select using (expires_at > now());
create policy "sightings_insert" on public.sightings for insert with check (auth.uid() = user_id);
create policy "sightings_delete" on public.sightings for delete using (auth.uid() = user_id);

-- Upvote RPC (atomic increment)
create or replace function public.upvote_sighting(sighting_id uuid)
returns void language plpgsql security definer as $$
begin
  update public.sightings set clout = clout + 1 where id = sighting_id;
end;
$$;

-- Auto-create profile on signup trigger
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, username, avatar_color)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', 'anon_' || substr(new.id::text, 1, 8)),
    (array['#ff2d78','#8b5cf6','#06b6d4','#f59e0b','#10b981'])[floor(random()*5+1)::int]
  );
  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ─── Migration: beacon + economy ────────────────────────────────────────────

alter table public.profiles
  add column if not exists beacon_on boolean default false,
  add column if not exists beacon_mode text default 'fuzzy' check (beacon_mode in ('exact','fuzzy','district')),
  add column if not exists beacon_lat double precision,
  add column if not exists beacon_lng double precision,
  add column if not exists tokens integer default 100,
  add column if not exists live_hours integer[] default '{}';

create index if not exists idx_profiles_beacon
  on public.profiles (beacon_on, beacon_lat, beacon_lng)
  where beacon_on = true;

-- Update own beacon status + location
create or replace function public.update_beacon(
  p_on boolean, p_mode text,
  p_lat double precision default null, p_lng double precision default null
) returns void language plpgsql security definer as $$
begin
  update public.profiles
  set beacon_on = p_on, beacon_mode = p_mode, beacon_lat = p_lat, beacon_lng = p_lng
  where id = auth.uid();
end; $$;

-- Nearby broadcasters
create or replace function public.nearby_broadcasters(
  p_lat double precision, p_lng double precision, p_km double precision default 1.5
) returns table (id uuid, username text, avatar_color text, clout integer, beacon_mode text, lat double precision, lng double precision)
language sql security definer as $$
  select p.id, p.username, p.avatar_color, p.clout, p.beacon_mode, p.beacon_lat, p.beacon_lng
  from public.profiles p
  where p.beacon_on = true
    and p.beacon_lat is not null
    and abs(p.beacon_lat - p_lat) < p_km / 111.0
    and abs(p.beacon_lng - p_lng) < p_km / (111.0 * cos(p_lat * pi() / 180.0))
  limit 20;
$$;

-- Leaderboard
create or replace function public.leaderboard(p_limit integer default 10)
returns table (username text, avatar_color text, clout integer)
language sql security definer as $$
  select p.username, p.avatar_color, p.clout
  from public.profiles p
  order by p.clout desc
  limit p_limit;
$$;

-- Award tokens on scene drop
create or replace function public.award_drop(p_user_id uuid)
returns void language plpgsql security definer as $$
begin
  update public.profiles set tokens = tokens + 10, clout = clout + 1 where id = p_user_id;
end; $$;

-- Save live hours
create or replace function public.save_live_hours(p_hours integer[])
returns void language plpgsql security definer as $$
begin
  update public.profiles set live_hours = p_hours where id = auth.uid();
end; $$;
