#!/usr/bin/env bash
# Integration tests for pls shell integrations
# Basic smoke tests to verify shell functions load and parse correctly

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INTEGRATION_DIR="$SCRIPT_DIR/shell-integrations"
BIN_DIR="$SCRIPT_DIR/bin"

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NC="\033[0m"

tests_passed=0
tests_failed=0

test_case() {
  local name="$1"
  echo -e "${YELLOW}[TEST]${NC} $name"
}

pass() {
  echo -e "${GREEN}✓ PASS${NC}"
  ((++tests_passed))
}

fail() {
  local reason="$1"
  echo -e "${RED}✗ FAIL${NC}: $reason"
  ((++tests_failed))
}

# Test 1: Verify pls-engine exists and is executable
test_case "pls-engine exists and is executable"
if [[ -x "$BIN_DIR/pls-engine" ]]; then
  pass
else
  fail "pls-engine not found or not executable at $BIN_DIR/pls-engine"
fi

# Test 2: Verify pls-engine supports --version
test_case "pls-engine --version flag works"
if output=$("$BIN_DIR/pls-engine" --version 2>&1); then
  if [[ "$output" =~ ^pls-engine ]]; then
    pass
  else
    fail "Version output format unexpected: $output"
  fi
else
  fail "pls-engine --version failed"
fi

# Test 3: Verify bash.sh has pls function
test_case "bash.sh defines pls function"
if grep -q "^pls()" "$INTEGRATION_DIR/bash.sh"; then
  pass
else
  fail "pls function not found in bash.sh"
fi

# Test 4: Verify zsh.sh has pls function
test_case "zsh.sh defines pls function"
if grep -q "^pls()" "$INTEGRATION_DIR/zsh.sh"; then
  pass
else
  fail "pls function not found in zsh.sh"
fi

# Test 5: Verify fish.fish has pls function definition
test_case "fish.fish defines pls function"
if grep -q "^function pls" "$INTEGRATION_DIR/fish.fish"; then
  pass
else
  fail "pls function not found in fish.fish"
fi

# Test 6: Verify bash.sh sources correctly
test_case "bash.sh sources without errors"
if bash -n "$INTEGRATION_DIR/bash.sh" 2>/dev/null; then
  pass
else
  fail "bash.sh has syntax errors"
fi

# Test 7: Verify zsh.sh sources correctly
test_case "zsh.sh sources without errors"
if bash -n "$INTEGRATION_DIR/zsh.sh" 2>/dev/null; then
  pass
else
  fail "zsh.sh has syntax errors"
fi

# Test 8: Verify fish.fish has valid syntax (if fish is available)
test_case "fish.fish has valid syntax"
if command -v fish >/dev/null 2>&1; then
  if fish -n "$INTEGRATION_DIR/fish.fish" 2>/dev/null; then
    pass
  else
    fail "fish.fish has syntax errors"
  fi
else
  echo -e "${YELLOW}⊘ SKIP${NC} Fish shell not installed"
fi

# Test 9: Verify install.sh exists and is executable
test_case "install.sh exists and is executable"
if [[ -x "$SCRIPT_DIR/install.sh" ]]; then
  pass
else
  fail "install.sh not executable"
fi

# Test 10: Verify install.sh has valid bash syntax
test_case "install.sh has valid bash syntax"
if bash -n "$SCRIPT_DIR/install.sh" 2>/dev/null; then
  pass
else
  fail "install.sh has syntax errors"
fi

# Test 11: Verify config file exists
test_case "config.json.example exists"
if [[ -f "$SCRIPT_DIR/config/config.json.example" ]]; then
  pass
else
  fail "config.json.example not found"
fi

# Test 12: Verify config JSON is valid
test_case "config.json.example is valid JSON"
if command -v jq >/dev/null 2>&1; then
  if jq empty "$SCRIPT_DIR/config/config.json.example" 2>/dev/null; then
    pass
  else
    fail "config.json.example is not valid JSON"
  fi
else
  echo -e "${YELLOW}⊘ SKIP${NC} jq not installed"
fi

# Summary
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo -e "Passed: ${GREEN}$tests_passed${NC}"
echo -e "Failed: ${RED}$tests_failed${NC}"
echo "Total:  $((tests_passed + tests_failed))"
echo "=========================================="

if [[ $tests_failed -gt 0 ]]; then
  exit 1
fi

exit 0
