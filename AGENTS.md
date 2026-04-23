# AGENTS.md

This file defines repository conventions for coding agents and automation contributors.

## Operating Principles

- Make minimal, deliberate changes tied to the stated task.
- Preserve readability and module boundaries over clever shortcuts.
- Favor explicit behavior over implicit behavior.
- Keep local-first and safety-first assumptions intact.

## Change Discipline

- Do not introduce destructive behavior silently.
- Any operation that can materially alter system state must require explicit confirmation.
- Prefer dry-run pathways when adding new state-changing logic.
- Preserve evidence-first behavior for triage workflows.

## Module Boundary Rules

- Keep shared runtime logic in `src/core`.
- Keep command orchestration in `src/commands`.
- Keep evidence gathering in `src/collectors`.
- Avoid cross-layer coupling that bypasses core abstractions.
- If a new capability spans layers, update `docs/module-spec.md`.

## Documentation Rules

- Update docs whenever commands, options, artifacts, or module responsibilities change.
- At minimum, review and update:
  - `docs/commands.md`
  - `docs/module-spec.md`
  - `README.md`
- Add TODO markers in code/docs for incomplete implementation segments.

## Testing Rules

- Add or update tests for behavior changes, not only syntax changes.
- Prefer fast unit tests for parser and contract logic.
- Use integration tests for end-to-end command behavior.

## Security and Safety Rules

- Never log sensitive secrets in plaintext.
- Keep escalation output explicit and operator-reviewable.
- Treat external LLM interactions as untrusted boundaries.
- Do not claim AV/EDR equivalence in docs or interfaces.

## Pull Request Expectations

- State what changed and why.
- List any TODOs intentionally left unresolved.
- Call out safety-impacting changes.
- Include doc updates in the same change set when applicable.

