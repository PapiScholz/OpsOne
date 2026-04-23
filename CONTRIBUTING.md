# Contributing to OpsOne

## Scope

OpsOne is an operations/security-adjacent tool. Contributions should prioritize safety, transparency, and maintainability.

## Development Guidelines

- Keep features modular (`src/core`, `src/commands`, `src/collectors`).
- Favor clear interfaces and predictable output contracts.
- Add TODO markers for unfinished implementation paths.
- Avoid adding hidden side effects or implicit state changes.

## Workflow

1. Fork/branch from `main`.
2. Implement focused changes with docs updates.
3. Run local checks:
   - PSScriptAnalyzer lint
   - Pester tests
4. Submit PR with context, risks, and follow-up TODOs.

## Coding Standards

- Use English for all code, comments, docs, and interfaces.
- Keep functions small and responsibility-focused.
- Prefer explicit parameter names and structured outputs.
- Ensure command stubs expose help and predictable behavior.

## Documentation Expectations

If you change commands, modules, or artifact contracts, update:

- `README.md`
- `docs/commands.md`
- `docs/module-spec.md`
- `docs/safety-model.md` (when safety semantics change)

## Security Reporting

Please do not open public issues for sensitive vulnerabilities. See [SECURITY.md](SECURITY.md) for private disclosure instructions.

