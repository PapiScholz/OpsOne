# OpsOne Roadmap

## 1. Product North Star

### End-State Definition

OpsOne 1.0 is a professional, local-first Windows operations product that delivers reproducible triage, safe tuning, common repairs, security posture visibility, and escalation-ready evidence packages without silent system changes.

### What "Professional Product" Means for OpsOne

- [ ] Deliver a stable, documented command contract for `triage`, `tune`, `repair`, `security`, and `escalate`.
- [ ] Enforce explicit operator intent for any state-changing action.
- [ ] Produce deterministic, integrity-verifiable artifact bundles suitable for analyst handoff.
- [ ] Ship with installer-grade packaging, code signing, versioned release process, and rollback-aware updates.
- [ ] Maintain test and documentation quality gates that block unsafe or contract-breaking changes.

### Primary User

- [ ] Serve Windows operators and incident responders who need trustworthy local diagnostics and guided remediation.
- [ ] Support security-adjacent IT practitioners who need evidence-first workflows before tuning or repair actions.

### Trust Guarantees Required by 1.0

- [ ] Local-first by default: no automatic external transmission.
- [ ] Evidence-first ordering: capture before mutation.
- [ ] Safe-by-default actions: dry-run and confirmation controls where state can change.
- [ ] Transparent outputs: structured artifacts, logs, and explicit error surfaces.
- [ ] Clear product boundaries: not AV, not EDR, not remote control software.

## 2. Explicit Current State (Implemented vs Scaffold vs Limitations)

### Implemented in Repository Today

- [x] ~~CLI routing is implemented in `opsone.ps1` + `src/cli/Invoke-OpsOneCli.ps1` with global/command help and normalized JSON result output.~~
- [x] ~~Triage command collects baseline artifacts (processes, network connections, services, scheduled tasks, autoruns, Defender status, system summary) and optional installed software in `--full`.~~
- [x] ~~Prompt rendering for ChatGPT/Gemini/Claude exists via `src/core/Prompts.ps1` and prompt templates under `prompts/`.~~
- [x] ~~Per-run session/log/artifact layout and `result.json` output contract exist in `src/core/Session.ps1`, `src/core/Logging.ps1`, `src/core/Artifacts.ps1`, `src/core/Output.ps1`.~~
- [x] ~~Basic CI/lint/test scaffolding exists (`.github/workflows/*.yml`, Pester smoke + unit tests).~~

### Scaffold / Placeholder Status Today

- [ ] Tune command has planning scaffolding, but real action execution, rollback checkpoints, and per-action result telemetry are TODO.
- [ ] Repair command has routine scaffolding, but staged execution, command output parsing, and rollback guidance are TODO.
- [ ] Security command currently covers Defender + firewall baseline only; expanded controls are TODO.
- [ ] Triage bundle creation is still placeholder (`final-zip-placeholder.md`), with no deterministic packaging or integrity metadata yet.
- [ ] Packaging/release is placeholder (`packaging/package.ps1`, `release.yml`) and not production-grade delivery.
- [ ] Desktop shell is placeholder (`apps/desktop/README.md`) with no executable product.
- [ ] Go helper area is placeholder (`internal/go-helper/README.md`) with no implemented helper binaries.
- [ ] Artifact schemas under `schemas/artifacts` are placeholder-grade and not enforced as stable contracts.
- [ ] Redaction workflow for escalation artifacts is not implemented.

### Current Limitations

- [ ] Output schemas and artifact contracts are not yet hardened for strict compatibility guarantees.
- [ ] Test coverage is minimal and does not yet include full contract/schema/golden/regression gates.
- [ ] Collector fallback pathways for constrained/legacy Windows environments are incomplete.
- [ ] Signed bundles and signed executable distribution are not implemented.
- [ ] Installer-grade distribution path (including winget) is not implemented.

## 3. Phased Execution Roadmap to 1.0

### Priority Legend

- `P0` = 1.0 release-blocking work. Must be complete before `v1.0` GA.
- `P1` = Important work that strengthens adoption/operability, but can be sequenced after core `P0` blockers if needed.
- `P2` = Deliberately deferred work, primarily post-1.0 governance/expansion.

### Phase 1: Foundation Hardening

**Priority:** `P0`

**Objective**

Stabilize command/runtime contract, configuration behavior, and baseline safety enforcement across all command flows.

**Deliverables**

- [ ] Define and freeze `result.json` contract fields, status semantics, and error/message conventions.
- [ ] Add explicit contract version field to command outputs and docs.
- [ ] Normalize option parsing and validation for all commands (unknown flags, mutually exclusive modes, invalid profiles/providers).
- [ ] Introduce centralized safety policy checks in core helpers to avoid per-command drift.
- [ ] Add TODO-labeled guardrails where implementation is intentionally deferred.

**Exit Criteria**

- Contract tests pass for every command.
- All command help text and behavior match docs.
- Invalid input paths produce deterministic error payloads.

**Dependencies**

- Existing core modules under `src/core`.
- Current command handlers under `src/commands`.

**Notable Risks**

- Breaking consumers relying on current unversioned output assumptions.
- Inconsistent behavior if command-specific edge cases bypass shared validation.

### Phase 2: Triage Maturity

**Priority:** `P0`

**Objective**

Move triage from baseline collection to reproducible, high-signal incident evidence capture.

**Deliverables**

- [ ] Add collector-level diagnostics channel artifacts for partial/failed collections.
- [ ] Implement collector fallback paths for constrained hosts (scheduled tasks, network, services, Defender alternatives where feasible).
- [ ] Add anomaly hinting in incident summary (process, network, persistence indicators) with explicit confidence disclaimers.
- [ ] Capture collection timings and privilege context in triage metadata.
- [ ] Define quick vs full mode SLA targets and enforce collector timeout handling.

**Exit Criteria**

- Triage quick/full both produce complete artifact index even on partial collector failure.
- Incident summary includes clear signal + limitation notes.
- Fallback behavior is documented and test-covered.

**Dependencies**

- Foundation hardening completed.
- Collectors in `src/collectors`.

**Notable Risks**

- False confidence if heuristic hints are interpreted as verdicts.
- Performance regressions on low-resource endpoints.

### Phase 3: Prompt/Escalation Maturity

**Priority:** `P0`

**Objective**

Turn escalation into a controlled, reviewable bridge from local evidence to external analyst/LLM workflows.

**Deliverables**

- [ ] Implement `--run-id` artifact loading in `escalate` with validation against existing run directories.
- [ ] Add redaction workflow (interactive and policy-driven presets) before prompt generation/export.
- [ ] Add provider-specific token budgeting guidance and prompt profile variants.
- [ ] Version prompt templates and maintain prompt changelog in docs.
- [ ] Add operator review checklist artifact that must be acknowledged before external sharing.

**Exit Criteria**

- Escalation can reference a prior run deterministically.
- Redaction path is available and documented.
- Prompt outputs include traceable template/version metadata.

**Dependencies**

- Triage artifact consistency.
- Safety model expansion.

**Notable Risks**

- Privacy/legal exposure if redaction is incomplete.
- Provider drift causing prompt behavior changes.

### Phase 4: Tune Engine Maturity

**Priority:** `P0`

**Objective**

Implement safe, auditable tune actions with dry-run-first and rollback-aware execution.

**Deliverables**

- [ ] Replace tune placeholders with concrete low-risk actions and preflight checks.
- [ ] Add per-action execution record (`planned`, `skipped`, `applied`, `failed`, `rolled_back`).
- [ ] Add rollback metadata and operator instructions per action.
- [ ] Add allowlist policy for tune actions by profile.
- [ ] Add simulation parity: dry-run output matches apply path action graph.

**Exit Criteria**

- Non-dry-run cannot execute without explicit confirmation or `--yes`.
- Tune report contains action-level status and rollback notes.
- No hidden changes outside declared action list.

**Dependencies**

- Foundation safety policy.
- Artifact contract versioning.

**Notable Risks**

- Unintended performance side effects.
- Rollback incompleteness for certain Windows settings.

### Phase 5: Repair Engine Maturity

**Priority:** `P0`

**Objective**

Implement repair routines as staged, evidence-backed workflows with strict operator control.

**Deliverables**

- [ ] Convert repair scaffold into staged routine engine with pre/post snapshots.
- [ ] Capture command stdout/stderr artifacts for each routine (SFC, DISM, others as approved).
- [ ] Add routine-level risk classification and prerequisite checks.
- [ ] Add rollback/escalation guidance per failed routine.
- [ ] Add profile governance for future repair profiles without breaking `--basic` contract.

**Exit Criteria**

- Repair routines are deterministic and auditable.
- Pre/post state evidence exists for every applied routine.
- Failed routines return clear next-step guidance.

**Dependencies**

- Tune engine execution model.
- Logging and artifact contract hardening.

**Notable Risks**

- Repair commands can impact system stability if prerequisites are weak.
- Privilege variance across Windows editions/users.

### Phase 6: Security Bridge Maturity

**Priority:** `P0`

**Objective**

Expand security command from baseline snapshot into a robust posture bridge without claiming AV/EDR parity.

**Deliverables**

- [ ] Add checks for SmartScreen, BitLocker status, ASR baseline, and relevant Windows security settings where available.
- [ ] Implement capability detection and graceful degradation when modules are unavailable.
- [ ] Add explicit unsupported-state reporting instead of silent omission.
- [ ] Add security recommendation output with confidence and action-risk labels.
- [ ] Keep terminology constrained to posture visibility, not threat detection claims.

**Exit Criteria**

- Security outputs clearly separate observed facts from recommendations.
- Missing module/capability paths are explicit in artifacts.
- Docs and CLI help avoid AV/EDR equivalence language.

**Dependencies**

- Collector fallback framework.
- Documentation alignment.

**Notable Risks**

- Defender/API availability varies significantly by host policy/version.
- Over-scoping into detection promises.

### Phase 7: Artifact Packaging and Bundle Integrity

**Priority:** `P0`

**Objective**

Replace placeholder bundle flow with deterministic, integrity-verifiable packaging.

**Deliverables**

- [ ] Implement deterministic ZIP creation for triage/escalation package outputs.
- [ ] Add bundle manifest listing files, logical artifact types, and size/hash metadata.
- [ ] Add content hash generation for each artifact and for final bundle.
- [ ] Define bundle naming/version convention and retention behavior.
- [ ] Add verification command or utility function to validate bundle integrity.

**Exit Criteria**

- Same input artifacts produce reproducible manifest ordering.
- Integrity verification detects tampering/missing files.
- Bundle flow is documented and test-covered.

**Dependencies**

- Stable artifact schema and result contract versioning.

**Notable Risks**

- Non-determinism from file timestamp/ordering behavior.
- Hash/manifest drift during refactors.

### Phase 8: UX and GUI/Desktop Shell

**Priority:** `P1`

**Objective**

Introduce desktop shell that wraps CLI contracts and preserves safety model parity.

**Deliverables**

- [ ] Select desktop framework and document architecture decision.
- [ ] Implement run launcher for all major commands with mode/profile selectors.
- [ ] Implement operator confirmation UX for state-changing commands equivalent to CLI safety gates.
- [ ] Implement artifact browser and escalation review/redaction UI flows.
- [ ] Ensure GUI consumes the same result contract version and artifact manifest semantics as CLI.

**Exit Criteria**

- Desktop shell can execute and render major CLI scenarios without bypassing safeguards.
- GUI and CLI produce equivalent run semantics.
- Desktop packaging path is defined for distribution phases.

**Dependencies**

- Stable CLI contracts and bundle integrity layer.

**Notable Risks**

- Divergence between GUI wrappers and CLI behavior.
- Increased maintenance cost across languages/stacks.

### Phase 9: Distribution and Installation

**Priority:** `P0`

**Objective**

Move from repo-driven scripts to operator-friendly installation/update delivery.

**Deliverables**

- [ ] Define bootstrap installer script for controlled environment setup.
- [ ] Define portable package artifact format and update channel.
- [ ] Build installer-grade package with upgrade/uninstall behavior.
- [ ] Document installation prerequisites and minimum Windows support matrix.
- [ ] Add update verification behavior tied to signing and checksums.

**Exit Criteria**

- Operator can install/update without cloning repository.
- Upgrade path preserves runs and configuration safely.
- Install/uninstall flows are documented and tested.

**Dependencies**

- Packaging integrity outputs.
- Release engineering process.

**Notable Risks**

- Installer complexity on Windows variants.
- Upgrade regressions affecting trust.

### Phase 10: Code Signing and Trust Chain

**Priority:** `P0`

**Objective**

Establish verifiable authenticity for scripts/binaries/packages and published releases.

**Deliverables**

- [ ] Define signing scope (scripts, bundles, executables, manifests).
- [ ] Integrate signing into release pipeline with controlled key handling.
- [ ] Publish checksum/signature verification instructions for operators.
- [ ] Add CI validation for signed artifact presence and signature verification.
- [ ] Document trust chain and incident response for key compromise.

**Exit Criteria**

- Release artifacts are signed and verifiable.
- Verification instructions are practical and tested.
- Trust model docs include key rotation/compromise response.

**Dependencies**

- Packaging/release maturity.
- Secret management and secure CI controls.

**Notable Risks**

- Key management and operational overhead.
- False assurance if verification workflow is unclear.

### Phase 11: Testing and Quality Gates

**Priority:** `P0`

**Objective**

Create release-blocking quality system aligned with safety and contract stability.

**Deliverables**

- [ ] Expand unit tests for parsers, config, output contract constructors, and safety helpers.
- [ ] Expand integration tests for command flows (`triage`, `security`, `escalate`, `tune`, `repair`).
- [ ] Add golden-output tests for stable artifacts and summary/prompt generation.
- [ ] Add schema/contract validation tests for all produced artifacts.
- [ ] Add privilege-sensitive test matrix (standard user vs elevated contexts).
- [ ] Add packaging validation tests (artifact completeness, signatures, manifest integrity).
- [ ] Add regression suite for known bug classes and historical incidents.

**Exit Criteria**

- CI blocks merges on contract/safety regressions.
- Release candidate quality gates are documented and reproducible.
- Test evidence is retained for release sign-off.

**Dependencies**

- Stable contracts and packaging outputs.

**Notable Risks**

- Flaky Windows environment behavior in CI.
- Slow test pipelines reducing contributor velocity.

### Phase 12: Docs and Operator Guidance

**Priority:** `P0`

**Objective**

Publish complete operator-facing and contributor-facing documentation for 1.0 readiness.

**Deliverables**

- [ ] Update architecture docs with final layer responsibilities and extension points.
- [ ] Update command docs with mature options, outputs, and safety semantics.
- [ ] Finalize module spec with contract guarantees and boundary rules.
- [ ] Finalize prompts docs with versioning/redaction/token-budget guidance.
- [ ] Finalize troubleshooting playbook for collector failures and privilege variance.
- [ ] Add FAQ for common operator and security team concerns.
- [ ] Add operator playbooks for triage-first and repair/escalation workflows.
- [ ] Add release process doc with build, signing, validation, rollback steps.
- [ ] Add trust model doc with guarantees, limits, and anti-goals.
- [ ] Keep contribution guidance aligned with quality/safety gates.

**Exit Criteria**

- No major command/safety behavior undocumented.
- Docs reflect actual implementation, not intended scaffolding.
- Operators can run core workflows end-to-end from docs.

**Dependencies**

- Command and packaging maturity.

**Notable Risks**

- Documentation drift during late feature work.
- Under-specified trust limitations causing misuse.

### Phase 13: Extensibility/Module System

**Priority:** `P1`

**Objective**

Enable controlled extensibility without breaking core trust guarantees.

**Deliverables**

- [ ] Define extension contract for new collectors/actions with safety metadata requirements.
- [ ] Define compatibility rules for third-party/internal modules.
- [ ] Add extension validation tests for schema and safety policy compliance.
- [ ] Add documentation for extension lifecycle and review criteria.
- [ ] Add guardrails preventing extensions from bypassing confirmation/dry-run policy.

**Exit Criteria**

- Extension model is documented, testable, and policy-bound.
- Core contracts remain stable with extensions enabled.

**Dependencies**

- Core contract hardening.
- Testing quality gates.

**Notable Risks**

- Unsafe extensions weakening product trust.
- API surface instability for extension authors.

### Phase 14: Release Engineering

**Priority:** `P0`

**Objective**

Build repeatable release process with traceable versioning and governance.

**Deliverables**

- [ ] Replace release placeholder workflow with versioned build + validation + signing + publish pipeline.
- [ ] Define semantic versioning policy and compatibility commitments.
- [ ] Add release checklist and go/no-go criteria.
- [ ] Define hotfix flow with regression gate requirements.
- [ ] Publish release notes template focused on behavior, safety, and contract changes.

**Exit Criteria**

- Release pipeline is reproducible from tag to signed artifacts.
- Versioning and compatibility policy is enforced in practice.
- Hotfix and rollback flows are documented and exercised.

**Dependencies**

- Packaging, signing, and test gates.

**Notable Risks**

- Pipeline fragility delaying critical fixes.
- Inconsistent release metadata harming trust.

### Phase 15: Post-1.0 Considerations

**Priority:** `P2`

**Objective**

Maintain disciplined growth after 1.0 without violating trust boundaries.

**Deliverables**

- [ ] Define 1.x roadmap intake criteria (safety impact, maintenance cost, boundary alignment).
- [ ] Establish telemetry decision review process before any opt-in diagnostics expansion.
- [ ] Define long-term Windows compatibility maintenance policy.
- [ ] Define deprecation policy for commands/options/contracts.
- [ ] Define community feedback triage rubric for high-risk feature requests.

**Exit Criteria**

- Post-1.0 changes follow explicit governance.
- Boundary drift is prevented by documented anti-goal checks.

**Dependencies**

- 1.0 release completion.

**Notable Risks**

- Pressure to add unsafe automation.
- Maintenance overload across PowerShell + Go + desktop layers.

## 4. Versioned Milestones (Release-Blocking Scope Only)

Milestone gating rule: `v1.0` GA is gated by completion of `P0` roadmap phases; `P1` and `P2` items are intentionally non-blocking unless explicitly promoted.

### v0.1 (Current Baseline)

**What Must Exist**

- [x] ~~CLI scaffold with command routing and help output.~~
- [x] ~~Command set present: `triage`, `tune`, `repair`, `security`, `escalate`.~~
- [x] ~~Baseline triage collectors and prompt template rendering.~~
- [x] ~~Per-run artifacts/log/result output structure.~~
- [x] ~~Basic docs and CI/lint/test scaffolding.~~

**What Must Be Stable**

- [x] ~~Repository layout and module boundaries (`src/core`, `src/commands`, `src/collectors`).~~
- [x] ~~Core command invocation path from `opsone.ps1`.~~

**Intentionally Out of Scope**

- [x] ~~Production-grade tune/repair/security depth.~~
- [x] ~~Deterministic bundle integrity/signing/installer distribution.~~

### v0.2

**What Must Exist**

- [ ] Foundation hardening deliverables completed.
- [ ] Triage diagnostics/fallback behavior materially improved.
- [ ] Explicit contract versioning introduced in outputs/docs.
- [ ] Initial schema validation tests in CI.

**What Must Be Stable**

- [ ] Command error semantics and option validation behavior.
- [ ] Quick/full triage mode output shape.

**Intentionally Out of Scope**

- [ ] Desktop shell implementation.
- [ ] Full packaging/signing pipeline.

### v0.3

**What Must Exist**

- [ ] Prompt/escalation run-reference loading and redaction baseline.
- [ ] Deterministic bundle/manifest/hash MVP.
- [ ] Tune and repair engines moved beyond scaffold to controlled execution MVP.

**What Must Be Stable**

- [ ] Escalation safety workflow (review-before-share path).
- [ ] Artifact manifest format v1.

**Intentionally Out of Scope**

- [ ] Winget-grade delivery.
- [ ] Full desktop parity with CLI.

### v0.5

**What Must Exist**

- [ ] Mature tune action engine with rollback metadata.
- [ ] Mature repair routine engine with pre/post evidence and command output capture.
- [ ] Security bridge expanded beyond Defender/firewall baseline.
- [ ] Test suite includes unit/integration/golden/contract coverage for core flows.

**What Must Be Stable**

- [ ] Safety gates for state-changing commands.
- [ ] Command output contract and artifact schemas for core artifacts.

**Intentionally Out of Scope**

- [ ] Final 1.0 trust-chain and full installer distribution commitments.

### v0.7

**What Must Exist**

- [ ] Portable package and bootstrap installer path implemented.
- [ ] Release pipeline no longer placeholder.
- [ ] Signature/checksum verification workflow integrated at least for release artifacts.
- [ ] Desktop shell MVP for triage + artifact review.

**What Must Be Stable**

- [ ] Packaging and update behavior for supported install modes.
- [ ] Release checklist and semantic version process.

**Intentionally Out of Scope**

- [ ] Full GUI feature parity with every advanced CLI workflow.

### v0.9

**What Must Exist**

- [ ] 1.0 documentation set drafted and reviewed.
- [ ] Full quality gates and regression matrix active.
- [ ] Code-signing trust chain operational.
- [ ] Privilege-sensitive test matrix and Windows baseline matrix defined.

**What Must Be Stable**

- [ ] Artifact/result contract backward compatibility policy.
- [ ] Operator trust model and anti-goal language.

**Intentionally Out of Scope**

- [ ] Post-1.0 optional enhancements not required for professional baseline.

### v1.0

**What Must Exist**

- [ ] All release-blocking phases complete for CLI professional baseline.
- [ ] Deterministic, integrity-verifiable escalation package flow.
- [ ] Installer-grade and signed distribution path documented and supported.
- [ ] Comprehensive docs and operator playbooks published.
- [ ] Formal trust model and maintenance model published.

**What Must Be Stable**

- [ ] Command behavior and contracts suitable for downstream automation.
- [ ] Safety guarantees and review controls for state changes and external sharing.
- [ ] Release engineering and quality gate process.

**Intentionally Out of Scope**

- [ ] AV/EDR replacement capabilities.
- [ ] Remote management/orchestration agent behavior.
- [ ] Silent autonomous optimization without operator intent.

## 5. Command-by-Command Maturity Path

### `triage`

**Current State**

- [x] ~~Collects baseline artifacts and writes incident summary + provider prompt files.~~
- [x] ~~Supports `--quick` and `--full` modes.~~

**Missing Capabilities**

- [ ] Collector fallback coverage for constrained/legacy environments.
- [ ] Collector-level diagnostics artifacts.
- [ ] Deterministic final bundle creation and integrity metadata.
- [ ] Mature anomaly scoring/heuristics with confidence annotations.

**Pre-1.0 Maturity Requirements**

- [ ] Reliable partial-failure handling with explicit limitations in summary/result.
- [ ] Bundle manifest/hash output and verification compatibility.
- [ ] Stable quick/full artifact contract guarantees.

**Safety Requirements**

- [ ] No state mutation in triage code paths.
- [ ] Explicit marking of unavailable collectors to avoid false confidence.

**Output Requirements**

- [ ] Stable artifact descriptor metadata (`name`, `path`, `type`, `description`) plus versioned result contract.
- [ ] Incident summary includes observed facts, limitations, and next steps.

### `tune`

**Current State**

- [x] ~~Supports dry-run default + confirmation gate for non-dry-run mode.~~
- [ ] Real tune action execution is scaffold/TODO.

**Missing Capabilities**

- [ ] Action execution engine with preconditions and postconditions.
- [ ] Action-level result telemetry and rollback checkpoints.
- [ ] Policy allowlists and profile governance.

**Pre-1.0 Maturity Requirements**

- [ ] Implement bounded, documented low-risk tune actions.
- [ ] Guarantee parity between dry-run plan and apply graph.
- [ ] Expose rollback metadata and recovery guidance per action.

**Safety Requirements**

- [ ] Dry-run support mandatory.
- [ ] Explicit confirmation mandatory unless `--yes` is provided.
- [ ] No action outside declared plan.

**Output Requirements**

- [ ] Machine-readable action ledger (planned/applied/failed/rolled_back).
- [ ] Human-readable summary with risk and rollback guidance.

### `repair`

**Current State**

- [x] ~~Supports `--basic` profile, dry-run flag, and confirmation gate.~~
- [ ] Repair execution is scaffold/TODO.

**Missing Capabilities**

- [ ] Real staged routine execution with pre/post snapshots.
- [ ] Routine output capture/parsing and per-routine status model.
- [ ] Rollback and escalation guidance by failure mode.

**Pre-1.0 Maturity Requirements**

- [ ] Deterministic execution ordering and evidence capture.
- [ ] Stable basic profile semantics.
- [ ] Clear boundaries for high-risk routines.

**Safety Requirements**

- [ ] No non-dry-run execution without confirmation/`--yes`.
- [ ] Routine prerequisites and privilege checks before execution.
- [ ] Operator-visible warnings for medium/high risk actions.

**Output Requirements**

- [ ] Structured routine report with command outputs and statuses.
- [ ] Explicit next actions for failures and unresolved states.

### `security`

**Current State**

- [x] ~~Captures Defender status and firewall baseline into structured artifacts.~~
- [ ] Expanded checks (`--full`) are placeholder/TODO.

**Missing Capabilities**

- [ ] Broader posture checks (SmartScreen, BitLocker, ASR, other baseline controls).
- [ ] Capability discovery and unsupported-state reporting.
- [ ] Recommendation engine with risk labels and confidence.

**Pre-1.0 Maturity Requirements**

- [ ] Broadened posture coverage with explicit host capability matrix.
- [ ] Fact-vs-recommendation separation in outputs.
- [ ] Docs and language guardrails against AV/EDR equivalence.

**Safety Requirements**

- [ ] Security command remains read-only.
- [ ] Any future hardening actions require separate explicit confirmation pathways.

**Output Requirements**

- [ ] Structured snapshot with capability, findings, and limitations.
- [ ] Human-readable summary suitable for operator handoff.

### `escalate`

**Current State**

- [x] ~~Generates provider-specific prompt output for allowed providers.~~
- [ ] Referenced-run artifact loading and redaction are TODO.

**Missing Capabilities**

- [ ] Pull key context from referenced triage run.
- [ ] Redaction presets/workflow.
- [ ] Provider token budget/profile support.
- [ ] Explicit share-readiness checklist.

**Pre-1.0 Maturity Requirements**

- [ ] Deterministic referenced-run resolution and validation.
- [ ] Mandatory review flow before export/share.
- [ ] Prompt metadata versioning.

**Safety Requirements**

- [ ] No automatic external transmission.
- [ ] Operator review and redaction step before external use.
- [ ] External LLM boundary warnings embedded in outputs/docs.

**Output Requirements**

- [ ] Context memo, prompt artifact, and review status indicators.
- [ ] Traceable provider/template/version metadata.

## 6. Safety and Trust Roadmap

### Evidence Preservation Guarantees

- [ ] Capture triage evidence before any tune/repair mutation paths are executed in combined workflows.
- [ ] Preserve raw command outputs for repair/tune actions as artifacts.
- [ ] Prevent artifact overwrite by default within a run.

### Dry-Run Requirements

- [ ] `tune` and `repair` maintain dry-run support as first-class path.
- [ ] Dry-run output must match real apply action graph and ordering.
- [ ] CI tests must verify dry-run vs apply-plan parity.

### Confirmation Requirements

- [ ] State-changing paths require explicit operator confirmation.
- [ ] `--yes` bypass remains explicit and logged.
- [ ] Confirmation prompts include risk context.

### Rollback Expectations

- [ ] Every state-changing action defines rollback strategy or explicit non-reversible warning.
- [ ] Rollback guidance is emitted into artifacts and summary outputs.
- [ ] Failed rollback states are explicitly reported.

### Logging and Audit Trail Expectations

- [ ] All commands emit structured run logs with key decision points.
- [ ] Logs avoid secret plaintext leakage.
- [ ] Result + artifact manifests provide end-to-end action traceability.

### External LLM Boundary Handling

- [ ] Escalation outputs include untrusted-boundary warnings.
- [ ] Redaction and operator review are required before sharing externally.
- [ ] No automatic prompt submission to external providers.

### Local-Only Defaults

- [ ] Default operation remains local with no network dependency for core workflows.
- [ ] Any optional external integration remains opt-in and explicit.

### Telemetry Stance

- [ ] Keep default stance as no mandatory telemetry.
- [ ] If opt-in telemetry is added post-1.0, require explicit documentation, consent, and disable path.

### Privilege Model

- [ ] Detect and report privilege level per run.
- [ ] Handle non-admin limitations via explicit degraded-mode reporting.
- [ ] Avoid hard failure when safe read-only fallbacks are possible.

### Operator Review Before External Sharing

- [ ] Add explicit review checklist artifact to escalation bundles.
- [ ] Require operator acknowledgement state before marking bundle share-ready.

## 7. Artifact and Output Contract Roadmap

### Stable Artifact Schemas

- [ ] Replace placeholder schemas with strict, versioned schemas for each core artifact.
- [ ] Add required/optional fields with compatibility notes.
- [ ] Validate generated artifacts against schemas in CI.

### Artifact Manifest Design

- [ ] Introduce canonical manifest file in each run bundle.
- [ ] Include artifact types, generation source, timestamps, and schema versions.
- [ ] Define manifest extension policy for future artifacts.

### Integrity Metadata

- [ ] Add per-artifact hash metadata.
- [ ] Add bundle-level hash/signature metadata.
- [ ] Add verification command/helper.

### Deterministic Bundle Creation

- [ ] Define canonical file ordering and normalization rules.
- [ ] Ensure deterministic archive generation from same inputs.
- [ ] Add reproducibility tests.

### Result Contract Versioning

- [ ] Add `contractVersion` to result payload.
- [ ] Maintain version mapping docs and migration notes.
- [ ] Enforce breaking-change policy tied to semantic versioning.

### Backward Compatibility Guidance

- [ ] Define compatibility guarantees for 1.x line.
- [ ] Define deprecation process and notice periods.
- [ ] Document consumer migration playbooks.

### Human-Readable + Machine-Readable Outputs

- [ ] Keep operator summaries in Markdown for all major commands.
- [ ] Keep machine artifacts structured (JSON/CSV) with stable schemas.
- [ ] Ensure both views reference the same run metadata.

## 8. Packaging and Distribution Roadmap

### Stage A: Repo Script Usage (Current)

- [x] ~~Run directly via `opsone.ps1` / `opsone.cmd` from repository checkout.~~
- [ ] Harden script bootstrap docs and environment prerequisite checks.

**Trust and Maintenance Implications**

- [ ] High operator burden and low install assurance.

### Stage B: Bootstrap Installer

- [ ] Add bootstrap installer script for prerequisite setup and CLI registration.
- [ ] Add install logging and rollback instructions.

**Trust and Maintenance Implications**

- [ ] Improves repeatability but still depends on script trust and environment variance.

### Stage C: Portable Package

- [ ] Ship portable, versioned package with manifest/checksum.
- [ ] Add update/replace guidance preserving run history.

**Trust and Maintenance Implications**

- [ ] Better reproducibility; still requires manual verification discipline.

### Stage D: Signed Executable / Signed Package

- [ ] Produce signed executable/package artifacts in release pipeline.
- [ ] Publish verification steps and signature trust anchors.

**Trust and Maintenance Implications**

- [ ] Stronger authenticity guarantees; key lifecycle management becomes critical.

### Stage E: Winget / Installer-Grade Delivery

- [ ] Publish and maintain winget package (or equivalent installer-grade channel).
- [ ] Define update cadence, support matrix, and rollback policy.

**Trust and Maintenance Implications**

- [ ] Lowest operator friction; highest ongoing release discipline and compatibility maintenance required.

## 9. Testing and Quality-Gate Roadmap

### Unit Tests

- [ ] Expand coverage for `src/core` parsing/config/session/output helpers.
- [ ] Add deterministic tests for safety/confirmation policy helpers.

### Integration Tests

- [ ] Add command integration tests for all commands with representative option sets.
- [ ] Validate run directory structure and artifact presence rules.

### Golden Output Tests

- [ ] Add golden fixtures for incident summary and provider prompt render outputs.
- [ ] Add change-review process for golden fixture updates.

### Contract/Schema Tests

- [ ] Validate `result.json` contract version and required fields.
- [ ] Validate produced artifacts against JSON schemas.

### Command Smoke Tests

- [ ] Keep low-cost smoke tests for help and basic command invocation on Windows baseline.
- [ ] Add smoke tests for expected failures and invalid argument handling.

### Privilege-Sensitive Tests

- [ ] Add test lanes for standard user and elevated contexts where feasible.
- [ ] Assert degraded-mode behavior when privileges/modules are unavailable.

### Packaging Validation

- [ ] Validate package contents, manifest integrity, and signature presence.
- [ ] Validate installer upgrade/uninstall flows.

### Regression Testing

- [ ] Maintain regression suite for fixed bugs and safety incidents.
- [ ] Require regression pass for release candidates and hotfixes.

## 10. Documentation Roadmap

### Required 1.0 Documentation Set

- [ ] Architecture documentation (`docs/architecture.md`) updated to final design.
- [ ] Commands reference (`docs/commands.md`) updated with mature behaviors and outputs.
- [ ] Module specification (`docs/module-spec.md`) updated with stable contracts.
- [ ] Prompt system docs (`docs/prompts.md`) updated with versioning/redaction/token guidance.
- [ ] Troubleshooting guide (`docs/troubleshooting.md`) expanded for real failure paths.
- [ ] Safety model (`docs/safety-model.md`) finalized for 1.0 guarantees and limits.
- [ ] FAQ document added for operator adoption and expectation management.
- [ ] Operator playbooks added for triage/tune/repair/security/escalation workflows.
- [ ] Release process documentation added (build, sign, verify, publish, rollback).
- [ ] Trust model documentation added (assurance boundaries, anti-goals, verification path).
- [ ] Contribution guidance kept aligned (`CONTRIBUTING.md`, `AGENTS.md`).

### Documentation Quality Rules

- [ ] Every command or contract change updates relevant docs in same change set.
- [ ] TODO markers remain explicit when behavior is intentionally incomplete.
- [ ] Docs must not claim AV/EDR equivalence or autonomous remediation behavior.

## 11. Risks, Constraints, and Anti-Goals

### Risks and Constraints

- [ ] PowerShell complexity and shell/version differences can produce inconsistent behavior.
- [ ] Windows version drift can break collector APIs and command assumptions.
- [ ] Admin privilege variance can block data collection and repair pathways.
- [ ] Defender module availability may vary by policy/edition/environment.
- [ ] False confidence risk if heuristic summaries are interpreted as definitive diagnosis.
- [ ] Unsafe automation pressure may push for silent mutation behavior.
- [ ] Multi-stack maintenance burden (PowerShell + Go helper + desktop shell) can reduce quality.
- [ ] Legal/privacy risk in external escalation if redaction/review is weak.

### Anti-Goals

- [ ] Do not implement antivirus-style malware engine claims.
- [ ] Do not position product as EDR/SIEM replacement.
- [ ] Do not introduce remote endpoint orchestration in 1.0 baseline.
- [ ] Do not allow hidden or autonomous state changes.

## 12. 1.0 Measurable Success Criteria

- [ ] Reproducible triage runs produce stable artifact sets and deterministic bundle manifests.
- [ ] Stable output contract version with compatibility policy and migration guidance exists.
- [ ] Tune and repair flows are safe-by-default with dry-run, confirmation, and rollback metadata.
- [ ] Escalation package is trustworthy, reviewable, and integrity-verifiable before sharing.
- [ ] Installation/update path is documented and validated for supported Windows baseline.
- [ ] Operators can understand what happened, what changed, and what remains uncertain from outputs.
- [ ] Release process produces signed, verifiable artifacts with explicit trust instructions.

## 13. Post-1.0 Considerations

- [ ] Evaluate carefully bounded feature additions against trust model and anti-goals.
- [ ] Consider optional integrations only with explicit opt-in and documented risk boundaries.
- [ ] Maintain compatibility and deprecation policy discipline across 1.x releases.
- [ ] Expand playbooks/test coverage based on real operator feedback and incident learnings.
- [ ] Periodically re-audit safety model, privilege handling, and escalation privacy controls.
