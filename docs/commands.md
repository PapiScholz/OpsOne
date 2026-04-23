# Command Reference

## Global

```powershell
opsone help
opsone <command> --help
```

## triage

```powershell
opsone triage --quick
opsone triage --full
```

Purpose:

- Collect evidence artifacts.
- Generate incident summary and provider prompt files.

Expected triage artifacts:

- `processes.csv`
- `net_connections.csv`
- `services.csv`
- `scheduled_tasks.csv`
- `autoruns.json`
- `defender_status.json`
- `system_summary.json`
- `incident-summary.md`
- `llm-prompt-chatgpt.md`
- `llm-prompt-gemini.md`
- `llm-prompt-claude.md`
- `final-zip-placeholder.md` (placeholder flow)

## tune

```powershell
opsone tune --dry-run
```

Purpose:

- Stage safe optimization actions.
- Require explicit confirmation when dry-run is disabled.

## repair

```powershell
opsone repair --basic
opsone repair --basic --dry-run
```

Purpose:

- Run baseline repair playbooks with explicit safety controls.

## security

```powershell
opsone security --quick
opsone security --full
```

Purpose:

- Capture security posture snapshot (Defender + firewall baseline).

## escalate

```powershell
opsone escalate --provider chatgpt
opsone escalate --provider gemini --run-id <triage-run-id>
```

Purpose:

- Generate provider-specific prompt payloads for external LLM workflows.

