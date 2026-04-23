# Tests

Test layout follows a simple split:

- `tests/unit`: fast module-level tests.
- `tests/integration`: command-level smoke tests.

## Running Tests

```powershell
Invoke-Pester -Path tests
```

## TODO

- Expand command contract assertions.
- Add schema validation checks for produced artifacts.
- Add negative-path tests (invalid options, permission constraints).

