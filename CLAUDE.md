# SPATIA AI Office: notes for Claude

The AI-agent "office" for Mohamed Salah's real-estate work (SPATIA): AI employees that each own one job and send reports. Read `HANDOFF.md` first; it has the agreed plan, the standing decisions and what's next.

Talk to Mohamed in Egyptian Arabic, in plain words. He wants a partner: say the right path and move on it instead of handing him technical decisions.

## Separate from NextLevel
- This project is separate from the NextLevel tool (repo `spatiaeg/Next-Level`). Don't change NextLevel's code from here.
- The agents only **read** NextLevel's data from Supabase project `bwihskgdppzarjtuvmsq`, workspace SPATIA `00000000-0000-4000-8000-000000000001`. SELECT only.
- Any write to Supabase (rows, migrations, functions, secrets) needs Mohamed's explicit approval.

## Standing rules
- Agents recommend only: they never create, complete or reschedule tasks, follow-ups or deals without Mohamed's confirmation.
- No automated scraping of Dubizzle. No automated WhatsApp sending from a personal number: agents draft messages and Mohamed sends them. Use the official WhatsApp Business API later if volume grows.
- Never put API keys or customer data (names, phones) in the repo.

## Files
- `office-3d.html`: the 3D office page (Three.js 0.160 from jsDelivr). Serve with `python3 -m http.server`; `file://` won't load the modules.
- `models/`: the six employee avatars (GLB), converted from Microsoft Rocketbox (MIT, see `models/LICENSE-ROCKETBOX.txt`).
- `tools/rocketbox_to_glb.py`: Blender (`pip install bpy`) script that converts a Rocketbox avatar and retargets the walk / sit / idle clips.
- Published copy: Claude artifact "مكتب SPATIA الرقمي" (slug `3f6912ba-93ff-4741-b334-269b4b9d82d0`). There the models load from uploaded assets (`/_blob/<id>`).

## Workflow
- Work on a `claude/...` branch and open a PR with a short Arabic summary; Mohamed merges.
