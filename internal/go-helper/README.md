# internal/go-helper

Reserved space for future Go helper binaries.

## Intended Use Cases

- Performance-sensitive collectors.
- Native API integrations where PowerShell is less efficient.
- Structured helper tools invoked by `src/commands` with clear contracts.

## Constraints

- Keep Go helpers optional and modular.
- Preserve local-first behavior.
- Keep output schema compatible with PowerShell artifact contracts.

## TODO

- Add Go module initialization when first helper is implemented.
- Define JSON IPC contract between PowerShell and Go helper.

