-- ISE Equipment Checkout: Supabase schema

-- Part 1: checkouts table ------------------------------------------------
begin;

create table public.checkouts (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id),
  borrower_name text not null,
  student_id text not null,
  item text not null,
  due_date date not null,
  status text not null default 'Borrowed'
    check (status in ('Borrowed', 'Returned')),
  created_at timestamptz not null default now()
);

alter table public.checkouts enable row level security;
revoke all on table public.checkouts from anon, authenticated;
grant select, insert on table public.checkouts to authenticated;
grant update (status) on table public.checkouts to authenticated;

commit;

-- Part 2: checkouts access policies --------------------------------------
create policy "Signed in users can browse checkouts"
on public.checkouts for select to authenticated
using (true);

create policy "Users can create their own checkouts"
on public.checkouts for insert to authenticated
with check (auth.uid() = owner_id and status = 'Borrowed');

create policy "Users can return their own borrowed items"
on public.checkouts for update to authenticated
using (auth.uid() = owner_id and status = 'Borrowed')
with check (auth.uid() = owner_id and status = 'Returned');

-- Part 3: checkout_events table (written by Make, not by Vue) -------------
create table public.checkout_events (
  id uuid primary key default gen_random_uuid(),
  checkout_id uuid not null references public.checkouts(id),
  event_type text not null default 'created',
  created_at timestamptz not null default now(),
  unique (checkout_id, event_type)
);

alter table public.checkout_events enable row level security;
revoke all on table public.checkout_events from anon, authenticated;
