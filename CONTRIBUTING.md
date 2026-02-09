# Contributing to pls

Thank you for your interest in contributing to pls! This document provides guidelines and instructions for contributing.

## Code of Conduct

Be respectful and inclusive. Treat all contributors with courtesy and professionalism.

## Getting Started

### Prerequisites

- Bash 4.0+
- `jq` for JSON processing
- `shellcheck` for code quality checks
- `curl` for HTTP requests
- Ollama running with at least one language model

### Setup Development Environment

```bash
# Clone the repository
git clone https://github.com/GaelicThunder/pls.git
cd pls

# Install development dependencies
pip install pre-commit    # For git hooks
sudo apt-get install shellcheck   # For linting (Ubuntu/Debian)
brew install shellcheck   # For macOS

# Set up pre-commit hooks
pre-commit install
```

### Running Tests

```bash
# Run integration tests
bash tests/integration/test_shell_integration.sh

# Run with debug output
bash -x tests/integration/test_shell_integration.sh
```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
# or for bug fixes:
git checkout -b bugfix/issue-description
```

### 2. Make Changes

- Keep commits focused and atomic
- Write clear, descriptive commit messages
- Follow the existing code style

### 3. Code Quality

Before committing, ensure:

```bash
# Check shell syntax
bash -n bin/pls-engine
bash -n install.sh
bash -n shell-integrations/*.sh

# Run shellcheck
shellcheck -x bin/pls-engine
shellcheck -x shell-integrations/*.sh
shellcheck -x install.sh

# Run integration tests
bash tests/integration/test_shell_integration.sh
```

### 4. Pre-commit Hooks

If you've installed pre-commit hooks, they'll run automatically:

```bash
pre-commit run --all-files    # Run manually
```

You can bypass hooks (not recommended):

```bash
git commit --no-verify
```

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then open a PR on GitHub with:
- Clear title and description
- Reference to any related issues
- Summary of changes

## Code Style Guidelines

### Shell Scripting

- Use `#!/usr/bin/env bash` for shell scripts
- Always use `set -uo pipefail` or `set -eo pipefail` for safety
- Quote all variables: `"$var"` not `$var`
- Use `[[ ]]` for conditionals instead of `[ ]`
- Avoid `eval` where possible; if necessary, validate input thoroughly
- Add comments for complex logic

### Configuration

- Keep default configuration in `config/config.json.example`
- Document all configuration options
- Use sensible defaults
- Add new options to both example and default config in `bin/pls-engine`

### Documentation

- Update README.md for user-facing changes
- Update docs/configuration.md for config changes
- Add inline comments for complex functions
- Keep documentation accurate and up-to-date

## File Structure

```
pls/
├── bin/
│   └── pls-engine          # Main engine script
├── shell-integrations/      # Shell-specific integrations
│   ├── bash.sh
│   ├── zsh.sh
│   └── fish.fish
├── config/
│   └── config.json.example  # Example configuration
├── docs/
│   └── configuration.md     # Configuration documentation
├── tests/
│   └── integration/         # Integration tests
├── install.sh               # Installation script
├── README.md                # User documentation
└── CONTRIBUTING.md          # This file
```

## Types of Contributions

### Bug Fixes

- Include a test case that reproduces the bug
- Verify the fix works with the test
- Update documentation if behavior changes

### New Features

- Discuss major features in an issue first
- Include tests for new functionality
- Update README and configuration docs
- Follow existing code patterns

### Documentation

- Fix typos and improve clarity
- Add examples for complex features
- Keep code examples correct and tested
- Update docs when behavior changes

### Tests

- Add tests for new functionality
- Improve test coverage
- Fix flaky tests

## Pull Request Process

1. **Create PR**: Provide clear title and description
2. **Tests Pass**: Ensure all CI checks pass
3. **Code Review**: Address feedback from reviewers
4. **Merge**: Maintainers will merge when ready

### PR Title Format

- ✨ Feature: Add cool new feature
- 🐛 Fix: Resolve shell parsing issue
- 📝 Docs: Update configuration guide
- 🧪 Test: Improve test coverage
- ♻️ Refactor: Simplify logic in pls-engine

## Reporting Issues

### Bug Reports

Include:
- Operating system and shell version
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs (`pls --debug`)

### Feature Requests

Describe:
- Use case and motivation
- Expected behavior
- Possible implementation approach

## Questions or Need Help?

- Check existing issues and discussions
- Read documentation in `docs/`
- Open a discussion or issue

## Recognition

Contributors will be:
- Added to the contributors list in README
- Credited in release notes

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to pls! 🚀
