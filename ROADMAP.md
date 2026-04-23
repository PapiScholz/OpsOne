# OpsOne Roadmap

## Vision

Deliver a production-ready, local-first Windows operations toolkit that supports incident triage, safe remediations, security visibility, and analyst escalation workflows without introducing silent risk.

## Milestones

## v0.1 - Bootstrap Skeleton

- Repository scaffold with modular CLI architecture.
- Core command stubs: `triage`, `tune`, `repair`, `security`, `escalate`.
- Initial evidence collectors and artifact schema placeholders.
- Prompt template system for ChatGPT, Gemini, and Claude.
- Documentation baseline and CI/lint scaffolding.

## v0.2 - Execution Baseline

- Real collector implementations with error tolerance and richer metadata.
- Command-level policy enforcement (dry-run defaults, confirmation gates).
- Deterministic artifact manifests and integrity metadata.
- Initial Pester coverage for parser, collector contracts, and command outputs.

## v0.5 - Operational Maturity

- Stable tuning and repair playbooks with rollback guidance.
- Defender integration improvements and security bridge routines.
- Packaging and signed distributable flow.
- Optional Go helper prototypes for heavyweight collection operations.
- Better incident summary generation and escalation bundle quality.

## v1.0 - Professional Product

- Hardened command implementations and safety guardrails.
- Strong test coverage and release quality gates.
- Versioned output contracts and migration guidance.
- GUI/Desktop companion with parity against major CLI scenarios.
- Documentation completeness for operator workflows and trust model.

## Phased Workstreams

1. Foundation: CLI, modules, docs, and safety policy.
2. Data Quality: collectors, artifact schema validation, prompt quality.
3. Safe Actions: tune/repair hardening with explicit confirmation and dry-run.
4. Packaging: release process, signing, and install/update workflow.
5. UX Expansion: desktop app and guided workflows.

## Explicit Non-Goals

- Building a full antivirus engine.
- Becoming a full EDR platform.
- Remote endpoint orchestration in initial phases.
- Hidden or autonomous system modifications.

## Risks and Constraints

- Windows API and privilege differences across versions/editions.
- Potentially expensive collections on low-resource hosts.
- False confidence risk if placeholders are treated as production logic.
- Prompt leakage risk if escalation content is not operator-reviewed.
- Long-term maintenance overhead across PowerShell + future Go + GUI layers.

## Success Criteria

- Reproducible artifact capture with clear session boundaries.
- Operator trust through transparent, explicit command behavior.
- Safe-by-default posture with no silent destructive actions.
- Structured outputs ready for automation and downstream analysis.

