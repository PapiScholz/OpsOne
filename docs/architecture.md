# Architecture Overview

## Purpose

OpsOne is designed as a local-first orchestration layer for Windows triage and safe remediation workflows.

## Current Layers

1. CLI Entry
   - `opsone.ps1` and `opsone.cmd`
   - Routes commands and returns consistent JSON results.
2. Command Layer (`src/commands`)
   - Orchestrates command behavior and session lifecycle.
   - Defines command-specific help and options.
3. Core Layer (`src/core`)
   - Shared concerns: config, session, logging, artifacts, output contracts, utility helpers, prompt rendering.
4. Collector Layer (`src/collectors`)
   - Isolated data collection functions for Windows evidence.
5. Assets/Contracts
   - Prompt templates under `prompts`.
   - Artifact schema placeholders under `schemas/artifacts`.

## Data Flow

1. Command invocation starts a run session (`runId`).
2. Command gathers evidence and writes artifacts into `runs/<runId>/artifacts`.
3. Command writes `result.json` with metadata and artifact index.
4. Optional escalation prompt files are emitted for external LLM workflows.

## Key Principles

- Keep command orchestration separate from collector implementation.
- Keep collectors mostly read-only and side-effect free.
- Keep output contracts stable and machine-readable.
- Keep TODO markers explicit for unfinished behavior.

## Future Expansion

- Go helper binaries under `internal/go-helper` for heavy collectors.
- Desktop shell under `apps/desktop` that wraps the same command contracts.
- Packaging/signing pipeline for production-grade distribution.

