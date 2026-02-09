# Tests

This directory contains tests for the `pls` project.

## Integration Tests

Located in `integration/`, these tests verify basic shell integration functionality and script validity.

### Running Integration Tests Locally

```bash
# Run all integration tests
bash tests/integration/test_shell_integration.sh

# Or directly
./tests/integration/test_shell_integration.sh
```

### What's Tested

- ✓ `pls-engine` binary exists and is executable
- ✓ Version flag returns proper output
- ✓ Shell integration functions (`bash.sh`, `zsh.sh`, `fish.fish`) are defined
- ✓ All shell scripts have valid syntax
- ✓ Configuration file exists and is valid JSON
- ✓ Installer script is valid and executable

### Test Output

Tests use colored output:
- 🟢 **PASS**: Test succeeded
- 🔴 **FAIL**: Test failed (will show reason)
- ⊘ **SKIP**: Test skipped (e.g., tool not available)

## CI/CD Pipeline

Tests are automatically run on:
- Every push to `master`, `main`, or `feature/*` branches
- Every pull request to `master` or `main`

See `.github/workflows/lint-and-test.yml` for the CI configuration.

## Future Enhancements

- Unit tests for individual `pls-engine` functions
- Mocked Ollama integration tests
- Shell-specific functionality tests
