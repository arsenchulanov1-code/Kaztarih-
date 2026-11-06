-- Дала тарихы: база деректері. Supabase → SQL Editor → New query → осыны қойып Run бас.

create table if not exists public.players (
  uid     uuid primary key references auth.users(id) on delete cascade,
  name    text not null check (char_length(name) between 1 and 24),
  xp      int  not null default 0 check (xp between 0 and 1000000),
  rank    int  not null default 0 check (rank between 0 and 15),
  stars   int  not null default 0 check (stars between 0 and 1000),
  learned int  not null default 0 check (learned between 0 and 10000),
  created timestamptz not null default now(),
  updated timestamptz not null default now()
);
create index if not exists players_xp_idx on public.players (xp desc);

create table if not exists public.progress (
  uid     uuid primary key references auth.users(id) on delete cascade,
  name    text,
  login   text,
  p       jsonb not null default '{}'::jsonb,
  updated timestamptz not null default now()
);

create table if not exists public.admins (
  uid uuid primary key references auth.users(id) on delete cascade,
  by  uuid,
  at  timestamptz not null default now()
);

create or replace function public.is_admin() returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from public.admins where uid = auth.uid())
$$;

alter table public.players  enable row level security;
alter table public.progress enable row level security;
alter table public.admins   enable row level security;

-- Рейтинг: бәріне көрінеді (кірмегендерге де)
drop policy if exists players_read   on public.players;
drop policy if exists players_insert on public.players;
drop policy if exists players_update on public.players;
drop policy if exists players_delete on public.players;
create policy players_read   on public.players for select using (true);
create policy players_insert on public.players for insert to authenticated with check (uid = auth.uid() or public.is_admin());
create policy players_update on public.players for update to authenticated using (uid = auth.uid() or public.is_admin()) with check (uid = auth.uid() or public.is_admin());
create policy players_delete on public.players for delete to authenticated using (uid = auth.uid() or public.is_admin());

-- Толық прогресс: тек өзі және админдер
drop policy if exists progress_all on public.progress;
create policy progress_all on public.progress for all to authenticated
  using (uid = auth.uid() or public.is_admin()) with check (uid = auth.uid() or public.is_admin());

-- Админдер: кіргендер оқиды, тек админ өзгертеді
drop policy if exists admins_read  on public.admins;
drop policy if exists admins_write on public.admins;
create policy admins_read  on public.admins for select to authenticated using (true);
create policy admins_write on public.admins for all to authenticated using (public.is_admin()) with check (public.is_admin());

grant select on public.players to anon;
grant select, insert, update, delete on public.players, public.progress, public.admins to authenticated;

-- ӘКІМШІНІ ТАҢДАУ (тіркелгеннен кейін, өз логиніңді жаз):
-- insert into public.admins (uid) select id from auth.users where email = 'СЕНІҢ_ЛОГИНІҢ@dala-tarihy.kz';
