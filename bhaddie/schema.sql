-- Bhaddie Database Schema
-- Run against a Supabase project

-- Profiles (extends Supabase auth.users)
create table if not exists public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  username text unique not null,
  avatar_color text default '#ff2d78',
  clout integer default 0,
  created_at timestamptz default now()
);

-- Baddie sightings (self-reports, 24h TTL)
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
