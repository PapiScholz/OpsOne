# Safety Model

## Safety Baseline

OpsOne is built on "safe by default" execution:

- Prefer read-only evidence capture.
- Require explicit confirmation before meaningful state changes.
- Preserve dry-run pathways for tune/repair operations.
- Prioritize evidence retention before remediation.

## Guardrails

- No silent destructive behavior.
- No implicit registry/system mutation in triage/security commands.
- Every command should produce structured output with status and errors.
- Log command actions for post-run auditability.

## Confirmation Policy

- Commands with potential system mutation (`tune`, `repair`) must:
  1. Expose `--dry-run`
  2. Require explicit operator confirmation when not dry-run
  3. Support deliberate confirmation bypass with `--yes`

## Evidence Preservation

- Triage captures process, network, service, task, autorun, Defender, and system-summary artifacts.
- Escalation prompts are generated from local artifacts and not auto-transmitted.
- Final bundle creation is currently a placeholder flow pending integrity features.

## TODO Hardening

- TODO: Add artifact hashing and signed manifest.
- TODO: Add retention and secure deletion controls.
- TODO: Add command-level allowlist policies for sensitive actions.
- TODO: Add redaction workflow before external escalation.

