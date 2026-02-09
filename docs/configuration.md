# Configuration Guide

The `pls` configuration file is located at `~/.config/pls/config.json`. It's automatically created with default values when you first run `pls`.

## Basic Configuration

### Model Selection

```json
{
  "model": "codellama:13b"
}
```

Recommended models:
- `codellama:13b` - Best balance of accuracy and speed
- `codegemma:7b` - Faster, good for simple commands  
- `deepseek-coder:6.7b` - Excellent for complex shell scripting
- `llama3.1:8b` - General purpose, works well

To see available models: `ollama list`
To install a model: `ollama pull model-name`

### Ollama Connection

```json
{
  "ollama_url": "http://localhost:11434"
}
```

Change this if:
- Ollama runs on a different port
- Using a remote Ollama instance
- Using a custom Ollama setup

### Response Behavior

```json
{
  "temperature": 0.1,
  "stream": true,
  "max_tokens": 100
}
```

**Temperature** (0.0 - 1.0):
- `0.0-0.2`: Very consistent, deterministic commands
- `0.3-0.5`: Balanced creativity and consistency
- `0.6-1.0`: More creative but potentially inconsistent

**Stream**: 
- `true`: Real-time streaming with animation
- `false`: Wait for complete response

**Max Tokens**:
- Shell commands are typically short
- 100 tokens is usually sufficient
- Increase if you need longer, complex commands

## Advanced Configuration

### Custom System Prompts

```json
{
  "system_prompt": "You are a helpful shell command generator..."
}
```

Modify this to change the AI's behavior globally. For example:
- Add safety restrictions
- Request more verbose commands
- Focus on specific tools or patterns

### Shell-Specific Prompts

```json
{
  "shell_specific_prompts": {
    "fish": "Use Fish-specific syntax...",
    "bash": "Use Bash/POSIX syntax...",
    "zsh": "Use Zsh features when helpful..."
  }
}
```

These are appended to the base system prompt. Customize them to:
- Emphasize shell-specific features
- Prefer certain command patterns
- Avoid problematic constructs

## Environment Variables

Some settings can be overridden with environment variables:

```bash
export PLS_MODEL="llama3.1:8b"
export PLS_TEMPERATURE="0.2"
```

## Troubleshooting

### Connection Issues

**Problem**: "Cannot connect to Ollama" or "Connection refused"

**Solutions**:
1. Check if Ollama is running:
   ```bash
   ps aux | grep ollama
   curl http://localhost:11434/api/tags
   ```

2. Start Ollama if it's not running:
   ```bash
   ollama serve
   ```
   
3. If using custom Ollama URL, verify it's correct:
   ```bash
   curl http://your-ollama-host:port/api/tags
   ```

4. Check firewall settings if using remote Ollama:
   ```bash
   # Linux: test if port is open
   nc -zv localhost 11434
   
   # macOS: use lsof
   lsof -i :11434
   ```

### Model Issues

**Problem**: "Model not found" error

**Solutions**:
1. List available models:
   ```bash
   ollama list
   ```

2. Pull the required model:
   ```bash
   ollama pull gemma3:4b
   ollama pull codellama:13b
   ```

3. Update your config.json with the correct model name:
   ```bash
   jq '.model = "codellama:13b"' ~/.config/pls/config.json > /tmp/config.json && \
   mv /tmp/config.json ~/.config/pls/config.json
   ```

4. If a model fails to pull, try a smaller one:
   ```bash
   ollama pull gemma3:4b    # Lightweight, fast
   ```

### Performance Issues

**Problem**: Responses are very slow

**Solutions**:

1. **Check system resources**:
   ```bash
   # Check CPU and memory usage
   nvidia-smi  # For GPU info (if available)
   free -h     # Memory usage
   ```

2. **Use a smaller model**:
   ```json
   {
     "model": "gemma3:4b"
   }
   ```

3. **Use Fast Mode**:
   ```bash
   pls --fast "your command"
   ```
   Fast mode skips context analysis and generates immediately.

4. **Reduce `max_tokens`**:
   ```json
   {
     "max_tokens": 50
   }
   ```

5. **Disable streaming**:
   ```json
   {
     "stream": false
   }
   ```

6. **Increase temperature** (counterintuitive, but can help):
   ```json
   {
     "temperature": 0.2
   }
   ```

### Command Quality Issues

**Problem**: Generated commands are inaccurate or unsafe

**Solutions**:

1. **Be more specific** in your prompt:
   ```bash
   # Instead of:
   pls "find files"
   
   # Try:
   pls "find all .log files modified in the last 7 days"
   ```

2. **Use a better model**:
   ```bash
   ollama pull deepseek-coder:6.7b
   pls "your command"  # Will use new model from config
   ```

3. **Lower temperature** for deterministic output:
   ```json
   {
     "temperature": 0.05
   }
   ```

4. **Customize system prompt**:
   ```json
   {
     "system_prompt": "You are a shell command generator specializing in safe, efficient commands. Always use the GNU/POSIX compatible flags when available."
   }
   ```

5. **Try different shell-specific prompt**:
   ```json
   {
     "shell_specific_prompts": {
       "bash": "Generate strictly POSIX-compatible Bash commands. Prefer well-tested syntax."
     }
   }
   ```

6. **Check if model is suitable**:
   - Code-focused models work better: codellama, deepseek-coder
   - General models (llama, mistral) may be less precise
   - Try: `ollama pull deepseek-coder:6.7b`

### Missing Dependencies

**Problem**: "jq required" or "curl required"

**Solutions**:

For **jq**:
```bash
# Ubuntu/Debian
sudo apt install jq

# CentOS/RHEL
sudo yum install jq

# macOS
brew install jq

# Arch
pacman -S jq

# Verify installation
jq --version
```

For **curl**:
```bash
# Ubuntu/Debian
sudo apt install curl

# CentOS/RHEL
sudo yum install curl

# macOS
brew install curl

# Arch
pacman -S curl

# Verify installation
curl --version
```

### Configuration File Issues

**Problem**: Configuration not being read or reset to defaults

**Solutions**:

1. **Check if config exists**:
   ```bash
   cat ~/.config/pls/config.json
   ```

2. **Validate JSON syntax**:
   ```bash
   jq . ~/.config/pls/config.json
   ```

3. **Reset to defaults**:
   ```bash
   # Backup old config
   cp ~/.config/pls/config.json ~/.config/pls/config.json.bak
   
   # Remove to regenerate
   rm ~/.config/pls/config.json
   
   # Run pls to recreate
   pls "test" 2>/dev/null
   
   # Check new config
   cat ~/.config/pls/config.json
   ```

4. **Update specific option**:
   ```bash
   # Update model
   jq '.model = "deepseek-coder:6.7b"' ~/.config/pls/config.json > /tmp/config.json
   mv /tmp/config.json ~/.config/pls/config.json
   ```

### Shell Integration Issues

**Problem**: `pls` command not found in shell

**Solutions**:

1. **Verify installation**:
   ```bash
   which pls
   which pls-engine
   /usr/local/bin/pls-engine "test"
   ```

2. **Re-run installer**:
   ```bash
   cd /path/to/pls
   ./install.sh
   ```

3. **Source shell config manually**:
   ```bash
   # For Bash
   source ~/.bashrc
   
   # For Zsh
   source ~/.zshrc
   
   # For Fish
   source ~/.config/fish/config.fish
   ```

4. **Check shell integration file exists**:
   ```bash
   # Should see the pls function
   grep -n "^pls()" ~/.bashrc
   grep -n "^pls()" ~/.zshrc
   grep -n "^function pls" ~/.config/fish/config.fish
   ```

### Debug and Logging

**Problem**: Need more detailed information about what's happening

**Solutions**:

1. **Use --verbose flag**:
   ```bash
   pls --verbose "your command"
   ```

2. **Use --debug flag** for full output:
   ```bash
   pls --debug "your command" 2>&1
   ```

3. **Log output to file**:
   ```bash
   pls --debug "your command" 2> /tmp/pls-debug.log
   cat /tmp/pls-debug.log
   ```

4. **Test pls-engine directly**:
   ```bash
   pls-engine --verbose "test command" "bash"
   ```

### General Debugging Workflow

1. **First: check Ollama is running**:
   ```bash
   curl http://localhost:11434/api/tags
   ```

2. **Next: test with verbose output**:
   ```bash
   pls --verbose "simple command" 2>&1
   ```

3. **If still failing: use debug**:
   ```bash
   pls --debug "simple command" 2>&1 | head -50
   ```

4. **Check config is valid**:
   ```bash
   jq . ~/.config/pls/config.json
   ```

5. **Test with different model**:
   ```bash
   # Edit config
   nano ~/.config/pls/config.json
   # Change model to gemma3:4b
   ```

## Configuration Validation

To validate your configuration works:

```bash
# Test basic functionality
pls-engine "test command" 2>&1 | grep -i error

# Test with verbose output
pls --verbose "test command"

# Enable debug mode for full information
pls-engine --debug "test command"

# Use fast mode to isolate context issues
pls --fast "test command"
```

## Example Configurations

### Performance-focused

```json
{
  "model": "codegemma:7b",
  "temperature": 0.0,
  "stream": false,
  "max_tokens": 50
}
```

### Accuracy-focused

```json
{
  "model": "deepseek-coder:6.7b",
  "temperature": 0.1,
  "max_tokens": 200,
  "system_prompt": "You are an expert system administrator. Generate precise, safe shell commands. Always prefer the most reliable and widely supported syntax."
}
```

### Creative/Experimental

```json
{
  "model": "llama3.1:8b",
  "temperature": 0.4,
  "system_prompt": "Generate creative shell command solutions. You may use advanced features and one-liners when they're more elegant."
}
```

## Configuration Validation

To validate your configuration:

```bash
pls-engine "test command" 2>&1 | grep -i error
```

Or enable debug mode:

```bash
pls-engine --debug "test command"
```
