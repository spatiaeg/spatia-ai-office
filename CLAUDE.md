# SPATIA AI Office: notes for Claude

The AI-agent "office" for Mohamed Salah's real-estate work (SPATIA): AI employees that each own one job and send reports. Read `HANDOFF.md` first; it has the agreed plan, the standing decisions and what's next.

Talk to Mohamed in Egyptian Arabic, in plain words. He wants a partner: say the right path and move on it instead of handing him technical decisions.

## Separate from NextLevel
- This project is separate from the NextLevel tool (repo `spatiaeg/Next-Level`). Don't change NextLevel's code from here.
- The office has its **own database**: Supabase project `lexxmrjtgmvrnvnmerhf` ("SPATIA AI Office", schema in `supabase/office_db.sql`): `reports`, `market_observations`, `market_news`, `compounds`. Agents write only there. No client/owner names or phones in it.
- The agents only **read** NextLevel's data from Supabase project `bwihskgdppzarjtuvmsq`, workspace SPATIA `00000000-0000-4000-8000-000000000001`. SELECT only, never write. (The old `ai_office_reports` table there is no longer used; deleting it needs Mohamed's approval.)
- Agents also work from the open internet every run: news, market reports, the portals' public price-guide pages, and at most one public search page per area/compound and portal read like a person browsing. Every number is saved with its source URL. Never bulk-collect listings, page through results, log in, or get around blocks or captchas.
- Any write to Supabase (rows, migrations, functions, secrets) needs Mohamed's explicit approval.

## Standing rules
- Agents recommend only: they never create, complete or reschedule tasks, follow-ups or deals without Mohamed's confirmation.
- No automated scraping of Dubizzle. No automated WhatsApp sending from a personal number: agents draft messages and Mohamed sends them. Use the official WhatsApp Business API later if volume grows.
- Never put API keys or customer data (names, phones) in the repo.
- Everything an agent reports must be clickable (agreed 22 Nov 2026): clients `https://nextlevel-app-mu.vercel.app/#client/<clients.id>`, owners `#ownerP/<owner_id>`, lists `#followups` `#pipeline` `#properties` `#clients`, WhatsApp drafts as `https://wa.me/?text=<encoded>` (no phone in the link). NextLevel has no single-unit link yet (`#unit/<id>` is a suggested NextLevel task); until then units link to `#properties`.

## Files
- `office-3d.html`: the 3D office page (Three.js 0.160 from jsDelivr). Serve with `python3 -m http.server`; `file://` won't load the modules.
- `agents/`: one file per employee (job, report sections, schedule, status).
- `supabase/office_db.sql`: the office's own database (what agents write, what the page reads). `supabase/ai_office_reports.sql` is the old table on NextLevel, no longer used.
- `models/`: the six employee avatars (GLB), converted from Microsoft Rocketbox (MIT, see `models/LICENSE-ROCKETBOX.txt`).
- `tools/rocketbox_to_glb.py`: Blender (`pip install bpy`) script that converts a Rocketbox avatar and retargets the walk / sit / idle clips.
- Published copy: Claude artifact "مكتب SPATIA الرقمي" (slug `3f6912ba-93ff-4741-b334-269b4b9d82d0`). There the models load from uploaded assets (`/_blob/<id>`, the `BLOB` map), and the reports load through the viewer's Supabase connector (`mcp` capability, `execute_sql` SELECT on `reports` in the office project). The repo copy loads `models/*.glb` and only shows reports if `SUPA.key` is set locally (never commit a key).

## Workflow
- Work on a `claude/...` branch and open a PR with a short Arabic summary; Mohamed merges.
