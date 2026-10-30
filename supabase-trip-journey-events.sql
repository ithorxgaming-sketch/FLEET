-- FuelGuard PRO: trip journey checkpoints (start, break, resume, end)
-- Run in Supabase SQL Editor. Photos remain in the private fuel-proofs bucket.
create table if not exists public.trip_journey_events (
 id uuid primary key default gen_random_uuid(),
 trip_id uuid not null references public.trip_assignments(id) on delete cascade,
 driver_id uuid not null references auth.users(id) on delete cascade,
 truck_id uuid not null references public.trucks(id) on delete cascade,
 event_type text not null check (event_type in ('start','break_start','resume','end')),
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
alter table public.trip_journey_events enable row level security;
create index if not exists trip_journey_events_trip_created_idx on public.trip_journey_events(trip_id, created_at desc);
create index if not exists trip_journey_events_driver_idx on public.trip_journey_events(driver_id);
drop policy if exists "trip_journey_events_driver_insert" on public.trip_journey_events;
create policy "trip_journey_events_driver_insert" on public.trip_journey_events for insert to authenticated
 with check (driver_id = auth.uid() and exists (select 1 from public.trip_assignments t where t.id = trip_id and t.driver_id = auth.uid() and t.truck_id = truck_id and t.status in ('assigned','started')));
drop policy if exists "trip_journey_events_driver_select" on public.trip_journey_events;
create policy "trip_journey_events_driver_select" on public.trip_journey_events for select to authenticated using (driver_id = auth.uid());
drop policy if exists "trip_journey_events_manager_select" on public.trip_journey_events;
create policy "trip_journey_events_manager_select" on public.trip_journey_events for select to authenticated
 using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'manager'));
