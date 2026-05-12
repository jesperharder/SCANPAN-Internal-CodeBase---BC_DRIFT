# Project AGENTS.md

## Project Scope
- This repository is the BC25 AL project `SCANPAN CODEBASE Internal Development`.
- Current app declaration is in `app.json`: app id `69ac3231-c282-41ad-963a-6fcf8a96c55d`, range `50000-50400`, runtime `14.1`, platform `25.0.0.0`, target `OnPrem`.
- Treat sibling projects that reuse the same app id as parallel variants of the same customization line. Do not copy, publish, or package across variants without verifying the target project and environment.

## Repository Structure
- `src/` contains AL source objects grouped primarily by object type.
- `translations/` contains the generated master XLIFF and localized XLIFF files.
- `docs/` contains project notes, generated manuals, and BC25 environment/port documentation.
- `tools/` contains project support scripts.
- `.alpackages/` contains local AL dependency packages and should be checked before changing dependency versions.
- `Layouts/`, `img/`, `logo/`, and report layout folders contain report and visual assets used by AL objects.
- `_Code Versions/`, `old_app_codebase/`, `.snapshots/`, and `delete..Layouts/` are reference or historical areas; do not treat them as active source unless the user explicitly asks.

## Business Central Object Governance
- Before proposing, creating, or remapping AL object IDs, read `C:\Users\jespe\.codex\memories\bc-object-ranges.md`.
- Keep `C:\Users\jespe\.codex\memories\bc-projects.csv` and `C:\Users\jespe\.codex\memories\bc-object-inventory.csv` aligned with active BC projects.
- After adding a BC project or changing AL objects in a registered BC project, refresh the central inventory with `C:\Users\jespe\.codex\memories\bc-refresh-object-inventory.ps1` when practical.
- New tables require extra care because the documented BC25 table range is tight.
- Do not allocate production-dashboard codeunits in `50042-50050`; that micro-range is reserved for API codeunits.
- For the production dashboard redesign, keep `page 50044 "ProdControllingDashboard"` as the UI surface unless the user changes that decision.

## Stable Development Rules
- Inspect existing AL patterns before editing and keep changes narrowly scoped.
- Match the repository's existing naming, folder, and AL style even when personal preferences differ.
- Comments must be in English.
- Do not silently swallow errors. Raise actionable errors with enough context to diagnose the failing record, request, response, or service call.
- Do not add fallbacks unless the user explicitly asks for them.
- Do not mutate existing table fields in place for production dashboard schema work. Add replacement fields and mark old fields obsolete when needed.
- Do not store passwords, tokens, license keys, or one-off credential values in repository files, `Memory.md`, or documentation.

## Validation Rules
- After AL code changes, run the available AL compile/validation path for this workspace and report whether only existing warnings remain.
- After translation edits, validate that XLIFF XML parses and that localized files stay aligned with the generated master `.g.xlf`.
- After dependency changes in `app.json`, compare against `.alpackages/` and, when server validation is required, use the BC server-side app info scripts or `Get-NAVAppInfo`.
- After object additions, removals, or ID changes, refresh the central BC object inventory when practical.
- For generated manuals or documents, update the repeatable generator/source assets rather than only patching the output document.

## Git Rules
- The main working branch is `master` tracking `origin/master`.
- The working tree may contain unrelated user changes. Do not revert, reformat, or stage unrelated files.
- Use non-interactive git commands, especially `git --no-pager diff`.
- Check `git status --short --branch` before and after edits.

## Workflow Principles
- `AGENTS.md` stores stable project rules only and should change only when those rules change.
- `Memory.md` stores current project state, blockers, decisions, verified findings, and next checks.
- If a Memory item becomes a repeated rule, move it to `AGENTS.md`.
- If a Memory item becomes obsolete, replace it with current state instead of preserving a changelog.
