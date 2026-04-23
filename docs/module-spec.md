# Module Specification

## Core Modules (`src/core`)

- `Utils.ps1`
  - Argument parsing helpers.
  - Option coercion and confirmation prompts.
  - Repo path helpers.
- `Configuration.ps1`
  - Loads baseline config and resolves absolute run paths.
- `Session.ps1`
  - Creates run/session context and output directories.
- `Logging.ps1`
  - Initializes and appends structured log lines per run.
- `Artifacts.ps1`
  - Writes CSV/JSON/Markdown artifacts and returns artifact descriptors.
- `Output.ps1`
  - Produces normalized command result payloads and result file output.
- `Prompts.ps1`
  - Loads prompt templates and renders provider-specific prompt files.

## Command Modules (`src/commands`)

- `Triage.ps1`
  - Collects evidence artifacts and provider prompts.
- `Tune.ps1`
  - Plans safe optimization actions (scaffold).
- `Repair.ps1`
  - Plans/runs basic repair routines (scaffold).
- `Security.ps1`
  - Captures security posture snapshots.
- `Escalate.ps1`
  - Generates provider-specific escalation prompts.

## Collector Modules (`src/collectors`)

- `Processes.ps1`
- `NetworkConnections.ps1`
- `Services.ps1`
- `ScheduledTasks.ps1`
- `Autoruns.ps1`
- `InstalledSoftware.ps1`
- `DefenderStatus.ps1`
- `SystemSummary.ps1`

Each collector should:

- Prefer read-only operations.
- Return structured objects (no raw text when avoidable).
- Handle failures gracefully with TODO-tagged fallback notes.

## Contract Rules

- Commands must return the standardized result object (`command`, `status`, `runId`, `metadata`, `artifacts`, `messages`, `errors`).
- Artifact descriptors should include `name`, `path`, `type`, and `description`.
- Breaking output contract changes require docs + test updates.

