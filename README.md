# OpsOne

OpsOne is a local-first Windows operations tool for triage, safe tuning, common repairs, security posture checks, and escalation packaging.

It orchestrates evidence collection, low-risk optimizations, repair routines, Microsoft Defender visibility, and provider-specific LLM prompt generation (ChatGPT, Gemini, Claude).

## What OpsOne Is

- A practical incident-response helper for Windows endpoints.
- A repeatable CLI workflow for collecting and preserving diagnostics.
- A safety-first framework for staged system tuning and repair.
- A bridge between local evidence and external analyst/LLM escalation.

## What OpsOne Is Not

- Not an antivirus replacement.
- Not an EDR or SIEM platform.
- Not a remote command-and-control agent.
- Not a silent optimizer that changes systems without operator intent.

## Command Philosophy

OpsOne commands are designed to be explicit and auditable:

- `local-first`: work from local machine state before any external dependency.
- `safe-by-default`: default behaviors avoid risky or destructive operations.
- `confirm-before-change`: any meaningful system change should require explicit confirmation.
- `dry-run-first`: commands that can change state support dry-run mode.
- `evidence-preservation`: triage prioritizes durable artifact capture.

## Initial Command Surface

- `opsone triage --quick`
- `opsone triage --full`
- `opsone tune --dry-run`
- `opsone repair --basic`
- `opsone security --quick`
- `opsone escalate --provider chatgpt`

Use `opsone help` or `opsone <command> --help` for command-specific help.

## Repository Layout

- `opsone.ps1` / `opsone.cmd`: CLI entrypoints.
- `src/core`: shared runtime modules (config, logging, artifacts, session, output, utilities).
- `src/commands`: command handlers.
- `src/collectors`: evidence collectors.
- `prompts`: LLM prompt templates.
- `schemas/artifacts`: JSON schema placeholders for artifacts.
- `docs`: architecture, safety model, module specs, command docs, and troubleshooting.
- `tests`: unit and integration test scaffolding.
- `.github/workflows`: CI/lint/release placeholders.
- `packaging`: packaging scripts.
- `apps/desktop`: future GUI/Desktop shell.
- `internal/go-helper`: future Go helper module space.

## Quick Start

```powershell
# From repository root
.\opsone.ps1 triage --quick
.\opsone.ps1 security --quick
.\opsone.ps1 escalate --provider chatgpt
```

To invoke without `.ps1`, use the bundled command shim:

```powershell
.\opsone.cmd triage --full
```

## Safety Note

This scaffold intentionally contains TODO markers where real operational logic still needs implementation and hardening. Until those TODO items are completed and validated, treat output as development-grade scaffolding.

## Future Direction

- Packaged CLI release pipeline (signed artifacts).
- Desktop/GUI shell under `apps/desktop`.
- Optional Go helper binaries for performance-sensitive collection under `internal/go-helper`.
- Expanded policy controls, retention, and evidence chain-of-custody support.

See [ROADMAP.md](ROADMAP.md) for milestones.

