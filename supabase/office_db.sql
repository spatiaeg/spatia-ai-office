-- قاعدة داتا المكتب: Supabase project lexxmrjtgmvrnvnmerhf ("SPATIA AI Office")، منفصلة عن NextLevel.
-- اتعملت 22 نوفمبر 2026 بموافقة محمد (migration: office_core). الخطة المجانية.
-- مفيش أي صلاحية للزوار (anon): الصفحة بتقرا عن طريق Supabase connector بتاع محمد، والموظفين بيكتبوا عن طريق نفس الـ connector.
create table public.reports (
  id bigint generated always as identity primary key,
  agent text not null check (agent in ('followup','admin','compounds','medical','pf','owners')),
  run_at timestamptz not null default now(),
  headline text not null check (char_length(headline) <= 200),
  stats jsonb not null default '[]'::jsonb,
  top3 jsonb not null default '[]'::jsonb,
  body_md text
);
create index reports_latest on public.reports (agent, run_at desc);

create table public.market_observations (
  id bigint generated always as identity primary key,
  agent text not null,
  observed_at timestamptz not null default now(),
  source text not null,
  url text not null check (url ~ '^https?://'),
  area text, compound text, property_type text,
  listing_type text check (listing_type in ('Rent','Sale') or listing_type is null),
  bedrooms int, price_min numeric, price_max numeric, price_avg numeric, price_per_sqm numeric,
  note text
);
create index market_obs_lookup on public.market_observations (compound, area, property_type, listing_type, observed_at desc);

create table public.market_news (
  id bigint generated always as identity primary key,
  agent text not null,
  found_at timestamptz not null default now(),
  published_at date,
  title text not null, summary text, source text,
  url text not null unique check (url ~ '^https?://'),
  tags text[] not null default '{}'
);
create index market_news_recent on public.market_news (found_at desc);

create table public.compounds (
  id bigint generated always as identity primary key,
  name_en text not null unique, name_ar text, area text, developer text,
  aliases text[] not null default '{}',
  approved boolean not null default false,
  updated_at timestamptz not null default now()
);

alter table public.reports enable row level security;
alter table public.market_observations enable row level security;
alter table public.market_news enable row level security;
alter table public.compounds enable row level security;
revoke all on public.reports, public.market_observations, public.market_news, public.compounds from anon, authenticated;
