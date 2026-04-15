# Memory

## Working Agreements

- Comments in English only.
- Prefer functional programming over OOP.
- Use OOP classes only for connectors and interfaces to external systems.
- Write pure functions and avoid mutating input parameters or global state.
- Follow DRY, KISS, and YAGNI.
- Use strict typing everywhere.
- Check whether logic already exists before adding new logic.
- Avoid untyped variables and generic types.
- Never use default parameter values.
- Keep imports at the top of files.
- Write simple single-purpose functions and avoid flag-driven multi-mode behavior.
- Raise explicit and specific errors with actionable context.
- Do not hide root causes with catch-all handlers.
- No fallbacks unless explicitly requested.
- Prefer project-managed dependencies.
- Inspect the repository before editing.
- Keep changes minimal and directly related to the request.
- Match existing repository style when needed.
- Do not revert unrelated changes.
- Prefer `rg` for search.
- Use non-interactive commands.
- Use non-interactive git diff commands.
- Run relevant validation after code changes when available.
- Keep documentation in code or docstrings unless a separate document is clearly needed.

## Current Context

- Repository: `SCANPAN Internal CodeBase - BC25`
- Current task: assess whether Tetris can be embedded in a Business Central page and played inside Business Central.
- Findings so far:
- The app targets Business Central 25 on-prem (`runtime 14.1`, `platform 25.0.0.0`).
- The codebase uses standard page `usercontrol` elements for charts.
- No existing custom `controladdin` implementation or local web assets (`.js`, `.css`, `.html`) were found in `src`.
- Working tree already contains unrelated user changes and must not be reverted.
- 2026-04-15: Ported the `Product Line Code` column change for page `50020 SalesLine` from BC_TEST to BC25.
- Updated `src/table/SalesLineTMP.Table.al`, `src/codeunit/ScanpanMiscellaneous.Codeunit.al`, and `src/page/SalesLine.Page.al`.
- The value is populated from `Item."Product Line Code"` and exposed on the temporary list page for Excel export.
- Validation: local AL compile completed successfully in BC25 with existing project warnings only and no new compile errors from this port.
