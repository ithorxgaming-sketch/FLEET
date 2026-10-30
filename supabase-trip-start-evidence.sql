-- FuelGuard PRO: trip start evidence table and access policies
-- Run in Supabase SQL Editor after reviewing against your existing schema.
create table if not exists public.trip_start_evidence (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.trip_assignments(id) on delete cascade,
  driver_id uuid not null references auth.users(id) on delete cascade,
  truck_id uuid not null references public.trucks(id) on delete cascade,
  dashboard_photo_path text not null,
  odometer_km numeric(12,1) not null check (odometer_km >= 0),
  fuel_level text not null,
  fuel_pct integer check (fuel_pct between 0 and 100),
  lat double precision not null check (lat between -90 and 90),
  lng double precision not null check (lng between -180 and 180),
  accuracy_m numeric,
  captured_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table public.trip_start_evidence enable row level security;

create index if not exists trip_start_evidence_trip_idx on public.trip_start_evidence(trip_id);
create index if not exists trip_start_evidence_driver_idx on public.trip_start_evidence(driver_id);

-- Drivers can add/read only their own evidence.
drop policy if exists "trip_start_evidence_driver_insert" on public.trip_start_evidence;
create policy "trip_start_evidence_driver_insert"
  on public.trip_start_evidence for insert to authenticated
  with check (driver_id = auth.uid() and exists (select 1 from public.trip_assignments t where t.id = trip_id and t.driver_id = auth.uid() and t.truck_id = truck_id));
drop policy if exists "trip_start_evidence_driver_select" on public.trip_start_evidence;
create policy "trip_start_evidence_driver_select"
  on public.trip_start_evidence for select to authenticated
  using (driver_id = auth.uid());

-- Managers can read evidence for fleet oversight.
drop policy if exists "trip_start_evidence_manager_select" on public.trip_start_evidence;
create policy "trip_start_evidence_manager_select"
  on public.trip_start_evidence for select to authenticated
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'manager'));
