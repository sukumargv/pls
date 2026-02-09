# pls-engine API Documentation

This document provides technical documentation for developers working with `pls-engine` and extending the pls project.

## Overview

`pls-engine` is the core component that:
1. Reads user input (natural language command description)
2. Communicates with Ollama to generate shell commands
3. Handles shell-specific syntax and context awareness
4. Returns the generated command for execution

## Architecture

```
User Input
    ↓
pls-engine initialization & argument parsing
    ↓
[Fast Mode] → Single LLM call → Generate command
OR
[Context Mode] → Multi-step:
  1. Scan directory for context
  2. Identify relevant command
  3. Get help text
  4. Generate with context
    ↓
Output to stdout
```

## Configuration System

### Config File Location

- **User config**: `~/.config/pls/config.json`
- **Example config**: `config/config.json.example`

### Configuration Options

```json
{
  "model": "gemma3:4b",                    // Ollama model to use
  "ollama_url": "http://localhost:11434",  // Ollama API endpoint
  "temperature": 0.1,                      // LLM temperature (0.0-1.0)
  "stream": true,                          // Stream responses
  "max_tokens": 100,                       // Max response length
  "system_prompt": "...",                  // Base system prompt
  "shell_specific_prompts": {              // Shell-specific instructions
    "fish": "...",
    "bash": "...",
    "zsh": "..."
  },
  "ignored_files": [...],                  // Files to exclude from context
  "max_context_files": 20,                 // Max files to scan
  "max_help_text_length": 4096             // Max help text chars
}
```

## Main Functions

### `debug()`

Logs debug messages when `_DEBUG_MODE=1`.

```bash
debug "Message here"
```

**Output**: `[DEBUG] Message here` to stderr (only in debug mode)

### `error()`

Logs error messages in red.

```bash
error "Something went wrong"
```

**Output**: `[ERROR] Something went wrong` to stderr

### `info()`

Logs informational messages in blue.

```bash
info "Starting process..."
```

**Output**: `[INFO] Starting process...` to stderr

### `show_thinking()`

Displays animated spinner while an external process runs.

```bash
show_thinking $pid
```

### `create_default_config()`

Creates default configuration if none exists.

```bash
create_default_config
```

**Creates**: `~/.config/pls/config.json` with sensible defaults

### `stream_response()`

Core function that communicates with Ollama and streams the response.

```bash
stream_response "$model" "$url" "$prompt" "$temperature"
```

**Parameters**:
- `model`: Ollama model name (e.g., "gemma3:4b")
- `url`: Ollama URL (e.g., "http://localhost:11434")
- `prompt`: The full prompt to send to the model
- `temperature`: LLM temperature value

**Returns**: Generated command to stdout

**Process**:
1. Validates Ollama connection
2. Creates JSON payload with jq
3. Streams response from Ollama API
4. Parses streaming JSON
5. Extracts command text
6. Cleans output (removes backticks, code blocks, etc.)

### `generate_command_fast()`

Fast mode: single LLM call without context analysis.

```bash
generate_command_fast "$user_prompt" "$shell"
```

**Parameters**:
- `user_prompt`: Natural language command description
- `shell`: Target shell (bash, zsh, fish)

**Returns**: Generated command

**Use when**: You want quick responses without file context

### `generate_command_with_context()`

Context-aware mode: multi-step process that analyzes current directory and command help.

```bash
generate_command_with_context "$user_prompt" "$shell"
```

**Parameters**:
- `user_prompt`: Natural language command description
- `shell`: Target shell (bash, zsh, fish)

**Returns**: Generated command

**Steps**:
1. **Scan directory**: Lists files (respecting ignored patterns)
2. **Identify command**: Asks LLM which command is relevant
3. **Validate**: Checks if command name is safe and exists
4. **Get help**: Captures `command --help` output
5. **Generate**: Creates command with context

**Fallback**: Falls back to fast mode if any step fails

## Data Flow

### Input Arguments

```bash
pls-engine [--debug] [--fast] [--version] <prompt> [shell]
```

**Flags**:
- `--debug`: Enable debug output
- `--fast`: Use fast mode (skip context analysis)
- `--version`: Show version

**Positional**:
- `prompt`: Natural language description (required, may be multiple words)
- `shell`: Target shell - bash, zsh, or fish (optional, defaults to bash)

**Examples**:
```bash
pls-engine "find large files" bash
pls-engine --debug "list directory" zsh
pls-engine --fast "grep pattern" fish
pls-engine --version
```

### Output

**Stdout**: The generated shell command (single line, no explanation)

**Stderr**: Informational/debug messages, prompts, streaming output

### Exit Codes

- `0`: Success - command generated
- `1`: Error - could not generate command, missing dependencies, etc.

## Ollama Integration

### API Endpoint

pls-engine uses the `/api/generate` endpoint:

```
POST http://localhost:11434/api/generate
```

### Request Format

```json
{
  "model": "gemma3:4b",
  "prompt": "Generate command: ...",
  "stream": true,
  "options": {
    "temperature": 0.1
  }
}
```

### Response Format

Streaming JSON, one object per line:

```json
{"response":"command","done":false}
{"response":" ","done":false}
{"response":"here","done":true}
```

## Shell-Specific Behavior

### Bash Integration

```bash
pls() {
    # ... argument parsing ...
    # Calls: pls-engine [flags] "$prompt" "bash"
    # Adds command to history with: history -s "$cmd"
    # Prompts for edit before execution
}
```

### Zsh Integration

```bash
pls() {
    # ... argument parsing ...
    # Calls: pls-engine [flags] "$prompt" "zsh"
    # Adds command to history with: print -s
    # Uses vared for editing
}
```

### Fish Integration

```fish
function pls
    # ... argument parsing ...
    # Calls: pls-engine [flags] "$prompt" "fish"
    # Uses commandline to set command
end
```

## Error Handling

### Connection Errors

```bash
if ! curl -s --head "$url" | head -n 1 | grep "200 OK" > /dev/null; then
    error "Cannot connect to Ollama at $url. Is 'ollama serve' running?"
    return 1
fi
```

### Missing Dependencies

```bash
command -v jq >/dev/null || { error "jq required"; exit 1; }
command -v curl >/dev/null || { error "curl required"; exit 1; }
```

### Security Validation

Identifies commands are validated:

```bash
# Only allow alphanumeric, dash, underscore
if ! [[ "$relevant_cmd" =~ ^[a-zA-Z0-9_.-]+$ ]]; then
    error "Identified command contains unsafe characters"
    generate_command_fast "$user_prompt" "$shell"
    return
fi

# Command must exist
if ! command -v "$relevant_cmd" >/dev/null 2>&1; then
    error "Identified command not found or not executable"
    generate_command_fast "$user_prompt" "$shell"
    return
fi
```

## Extension Points

### Adding a New Shell Integration

1. Create `shell-integrations/mynewshell.sh`
2. Validate shell syntax: `bash -n shell-integrations/mynewshell.sh`
3. Update `install.sh` to add installation logic
4. Add shell-specific prompt to config.json
5. Update tests in `test_shell_integration.sh`

### Modifying LLM Communication

The `stream_response()` function handles all Ollama communication. To:
- Change the API format: modify the `jq` payload construction
- Add new options: add to the options object
- Use a different endpoint: modify the curl URL

### Adding Configuration Options

1. Add to `config/config.json.example`
2. Add to default config in `create_default_config()`
3. Read in relevant function: `jq -r '.your_key // default' "$CONFIG_FILE"`

## Testing

### Unit Test Approach

To test individual functions in isolation:

```bash
# Source the script without execution
source bin/pls-engine

# Call a function
function_name "arg1" "arg2"
```

### Integration Tests

Located in `tests/integration/test_shell_integration.sh`:
- Verifies script syntax
- Checks function definitions
- Validates configuration
- Tests basic execution

Run with: `bash tests/integration/test_shell_integration.sh`

## Performance Considerations

### Context Mode Overhead

Context mode is slower because it:
1. Scans files (1-2 seconds)
2. Makes first LLM call to identify command (3-5 seconds)
3. Calls `--help` on identified command (1-2 seconds)
4. Makes final LLM call (3-5 seconds)

**Total**: ~8-14 seconds

### Fast Mode Speed

Fast mode only makes one LLM call: ~3-5 seconds

### Optimization Tips

- Use fast mode for simple, common commands
- Reduce `max_context_files` if scanning is slow
- Use smaller models (gemma3:4b) for faster responses
- Adjust `temperature` (lower = faster convergence)

## Debugging

### Enable Debug Mode

```bash
pls --debug "your command"
```

Shows:
- Configuration values
- Parsed arguments
- LLM prompts and responses
- File lists
- Help text

### Common Issues

**Issue**: "Cannot connect to Ollama"
- Solution: Ensure `ollama serve` is running

**Issue**: "jq required"
- Solution: Install jq package

**Issue**: Slow responses
- Solution: Try faster model, reduce context size, use --fast

**Issue**: Unsafe characters error in context mode
- Solution: Ensure command name is valid, fall back to fast mode

## Future Enhancements

Potential areas for improvement:
- [ ] Caching of help text for common commands
- [ ] Support for more shells (PowerShell, nushell, etc.)
- [ ] Multi-command generation
- [ ] Offline mode with pre-cached contexts
- [ ] Custom model providers (not just Ollama)
- [ ] Command history and learning

---

For questions or additional documentation, see [CONTRIBUTING.md](CONTRIBUTING.md) and [README.md](README.md).
