-- =========================================================
--  ESQUEMA DE BASE DE DATOS · Mi Equipo
--  Pega y ejecuta TODO este archivo en Supabase:
--  Panel de Supabase → SQL Editor → New query → pegar → Run
-- =========================================================

-- 1) Perfiles de usuario (guarda si cada usuario es admin o solo puede ver)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text,
  role text not null default 'viewer' check (role in ('admin','viewer')),
  created_at timestamptz default now()
);

-- 2) Cuando alguien nuevo se registra/es creado, se le crea automáticamente
--    un perfil con rol "viewer" (solo lectura) por defecto.
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, role)
  values (new.id, new.email, 'viewer');
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 3) Tabla con todos los datos del equipo (una única fila, id = 1)
create table if not exists public.team_data (
  id int primary key default 1,
  team_name text default 'Mi Equipo',
  crest jsonb default '{"color":"#1B3B30","symbol":"ball","image":null}',
  players jsonb default '[]',
  matches jsonb default '[]',
  media jsonb default '{}',
  media_latest bigint default 0,
  injuries jsonb default '{}',
  updated_at timestamptz default now(),
  constraint single_row check (id = 1)
);

insert into public.team_data (id)
values (1)
on conflict (id) do nothing;

-- 4) Seguridad a nivel de fila (RLS): esto es lo que de verdad impide
--    que un usuario "viewer" pueda modificar datos, aunque manipule la app.
alter table public.profiles enable row level security;
alter table public.team_data enable row level security;

drop policy if exists "ver mi propio perfil" on public.profiles;
create policy "ver mi propio perfil"
  on public.profiles for select
  to authenticated
  using (auth.uid() = id);

drop policy if exists "cualquier usuario autenticado puede leer los datos" on public.team_data;
create policy "cualquier usuario autenticado puede leer los datos"
  on public.team_data for select
  to authenticated
  using (true);

drop policy if exists "solo el admin puede modificar los datos" on public.team_data;
create policy "solo el admin puede modificar los datos"
  on public.team_data for update
  to authenticated
  using (exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'))
  with check (exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'));

-- =========================================================
--  Fin del script. Después de ejecutarlo, sigue la guía
--  "PASOS_DESPLIEGUE.md" para crear tu usuario admin.
-- =========================================================
