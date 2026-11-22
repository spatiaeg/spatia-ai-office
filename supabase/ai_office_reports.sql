-- اتعمل على Supabase project bwihskgdppzarjtuvmsq يوم 22 نوفمبر 2026 بموافقة محمد (migration: ai_office_reports).
-- كل موظف بيكتب سطر ملخص واحد بعد كل تقرير، وصفحة المكتب بتقرا آخر سطر لكل موظف.
-- ممنوع يتكتب فيه أسامي عملاء أو ملاك أو أرقام تليفونات.
create table public.ai_office_reports (
  id bigint generated always as identity primary key,
  workspace_id uuid not null,
  agent text not null check (agent in ('followup','admin','compounds','medical','pf','owners')),
  run_at timestamptz not null default now(),
  headline text not null check (char_length(headline) <= 200),
  stats jsonb not null default '[]'::jsonb,
  top3 jsonb not null default '[]'::jsonb
);
create index ai_office_reports_latest on public.ai_office_reports (workspace_id, agent, run_at desc);
alter table public.ai_office_reports enable row level security;
revoke all on public.ai_office_reports from anon, authenticated;
grant select (agent, run_at, headline, stats, top3, workspace_id) on public.ai_office_reports to anon, authenticated;
create policy "office page reads SPATIA summaries" on public.ai_office_reports
  for select to anon, authenticated
  using (workspace_id = '00000000-0000-4000-8000-000000000001');
