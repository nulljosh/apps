-- bcgd v4.0.0 — initial schema: orgs, profiles, parts, customers, jobs, leads
--
-- Multi-tenant from day one: every business table carries org_id, and RLS scopes
-- all rows to the caller's org via their profile. Best Choice Garage Doors is org #1.
-- The later B2B pivot is "turn on public signup," not a rewrite.
--
-- Apply: Supabase Dashboard → SQL Editor (paste + run), or `supabase db push`.

create extension if not exists pgcrypto;

-- Fixed org id for Best Choice Garage Doors. Referenced by the public booking form
-- (web/index.html) and the leads.org_id default. Keep these in sync.
--   BCGD_ORG_UUID = 11111111-1111-4111-8111-111111111111

-- ---------------------------------------------------------------- tables -----

create table if not exists public.orgs (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  org_id     uuid references public.orgs(id) on delete cascade,
  role       text not null default 'staff',
  full_name  text,
  created_at timestamptz not null default now()
);

-- Part field names mirror the dashboard/Swift Part shape (quantity, min_threshold,
-- cost, supplier). Status (out/low/ok) stays derived in the UI.
create table if not exists public.parts (
  id            text primary key default gen_random_uuid()::text,
  org_id        uuid not null references public.orgs(id) on delete cascade,
  name          text not null default '',
  sku           text not null default '',
  category      text not null default 'Other',
  quantity      integer not null default 0,
  min_threshold integer not null default 2,
  cost          numeric not null default 0,
  supplier      text not null default '',
  updated_at    timestamptz not null default now()
);

create table if not exists public.customers (
  id         text primary key default gen_random_uuid()::text,
  org_id     uuid not null references public.orgs(id) on delete cascade,
  name       text not null default '',
  phone      text not null default '',
  email      text not null default '',
  address    text not null default '',
  notes      text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.jobs (
  id           text primary key default gen_random_uuid()::text,
  org_id       uuid not null references public.orgs(id) on delete cascade,
  customer_id  text references public.customers(id) on delete set null,
  customer     text not null default '',
  phone        text not null default '',
  address      text not null default '',
  email        text not null default '',
  service      text not null default '',
  status       text not null default 'Scheduled',
  scheduled_at text not null default '',
  notes        text not null default '',
  created_at   text not null default ''
);

create table if not exists public.leads (
  id         text primary key default gen_random_uuid()::text,
  org_id     uuid not null default '11111111-1111-4111-8111-111111111111'
               references public.orgs(id) on delete cascade,
  name       text not null default '',
  phone      text not null default '',
  email      text not null default '',
  service    text not null default '',
  message    text not null default '',
  source     text not null default 'web',
  created_at timestamptz not null default now()
);

-- Seed org #1 (structural only — no fake parts/customers/jobs).
insert into public.orgs (id, name)
values ('11111111-1111-4111-8111-111111111111', 'Best Choice Garage Doors')
on conflict (id) do nothing;

-- ------------------------------------------------------------- functions -----

-- Caller's org id, resolved from their profile. SECURITY DEFINER so RLS policies
-- can call it without recursing into profiles' own policies.
create or replace function public.current_org_id()
returns uuid language sql stable security definer set search_path = public as $$
  select org_id from public.profiles where id = auth.uid()
$$;

-- Auto-create a profile (defaulting to org #1) when a new auth user signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, org_id, full_name)
  values (new.id, '11111111-1111-4111-8111-111111111111',
          new.raw_user_meta_data->>'full_name')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ------------------------------------------------------ row level security --

alter table public.orgs      enable row level security;
alter table public.profiles  enable row level security;
alter table public.parts     enable row level security;
alter table public.customers enable row level security;
alter table public.jobs      enable row level security;
alter table public.leads     enable row level security;

-- profiles: a user reads/updates only their own row.
drop policy if exists profiles_self_select on public.profiles;
create policy profiles_self_select on public.profiles for select using (id = auth.uid());
drop policy if exists profiles_self_update on public.profiles;
create policy profiles_self_update on public.profiles for update using (id = auth.uid());

-- orgs: members read their own org.
drop policy if exists orgs_member_select on public.orgs;
create policy orgs_member_select on public.orgs for select
  using (id = public.current_org_id());

-- parts / customers / jobs: full CRUD scoped to the caller's org.
drop policy if exists parts_org_all on public.parts;
create policy parts_org_all on public.parts for all
  using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

drop policy if exists customers_org_all on public.customers;
create policy customers_org_all on public.customers for all
  using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

drop policy if exists jobs_org_all on public.jobs;
create policy jobs_org_all on public.jobs for all
  using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

-- leads: org members read/manage their org's leads; the public booking form may
-- INSERT anonymously, but only into org #1 (the value defaulted on the column).
drop policy if exists leads_org_select on public.leads;
create policy leads_org_select on public.leads for select
  using (org_id = public.current_org_id());
drop policy if exists leads_org_update on public.leads;
create policy leads_org_update on public.leads for update
  using (org_id = public.current_org_id());
drop policy if exists leads_org_delete on public.leads;
create policy leads_org_delete on public.leads for delete
  using (org_id = public.current_org_id());
drop policy if exists leads_anon_insert on public.leads;
create policy leads_anon_insert on public.leads for insert
  to anon, authenticated
  with check (org_id = '11111111-1111-4111-8111-111111111111');

-- --------------------------------------------------------------- realtime ----
-- Let the dashboard receive live changes. Safe to ignore if a table is already
-- a member of the publication.
do $$
begin
  alter publication supabase_realtime add table public.parts, public.jobs, public.customers, public.leads;
exception when duplicate_object then null;
end $$;
