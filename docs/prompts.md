# Prompt System

## Goal

OpsOne prompt templates provide a controlled way to escalate local triage evidence into external LLM analysis workflows.

## Templates

- `prompts/chatgpt-triage.md`
- `prompts/gemini-triage.md`
- `prompts/claude-triage.md`

## Token Replacement

Templates support placeholder tokens:

- `{{RUN_ID}}`
- `{{RUN_MODE}}`
- `{{SYSTEM_NAME}}`
- `{{DEFENDER_ENABLED}}`
- `{{ARTIFACTS_PATH}}`
- `{{INCIDENT_SUMMARY}}`

## Rendered Output

During `triage` and `escalate`, rendered files are produced as:

- `llm-prompt-chatgpt.md`
- `llm-prompt-gemini.md`
- `llm-prompt-claude.md`

## Safety Guidance

- Prompts should request analysis, not autonomous execution.
- Prompts should enforce evidence-first reasoning.
- Prompts should avoid recommending destructive actions without confirmation.

## TODO

- TODO: Add prompt versioning and changelog.
- TODO: Add redaction presets for sensitive host metadata.
- TODO: Add provider token-budget profiles.

