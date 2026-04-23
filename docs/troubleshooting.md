# Troubleshooting

## Command Not Found (`opsone`)

- Use `.\opsone.ps1` or `.\opsone.cmd` from repository root.
- Ensure PowerShell execution policy allows script execution in your environment.

## Empty or Partial Artifacts

- Some collectors require privileges or specific Windows modules.
- Check run logs under `runs/<run-id>/logs/opsone.log`.
- TODO: Add collector-level error channel artifacts.

## Defender Status Collector Fails

- `Get-MpComputerStatus` may be unavailable in some environments.
- The scaffold falls back to an error payload in `defender_status.json`.

## Scheduled Task Collection Issues

- `Get-ScheduledTask` may require elevated permissions.
- TODO: Add `schtasks` fallback parser for older/locked-down systems.

## Tune/Repair Confirmation Blocks

- Non-dry-run tune/repair requires explicit confirmation.
- Use `--yes` only when operator intent is explicit.

## CI or Lint Failures

- Confirm `PSScriptAnalyzer` and `Pester` modules are available.
- Validate syntax: `pwsh -NoProfile -File .\opsone.ps1 help`.

