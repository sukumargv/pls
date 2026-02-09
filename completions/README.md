# Shell Completions for pls

This directory contains shell completion scripts for `pls`, enabling tab-completion of commands and flags in your shell.

## Installation

### Bash

1. **Using XDG Base Directory (Recommended)**:
```bash
mkdir -p ~/.local/share/bash-completion/completions
cp pls_completion.bash ~/.local/share/bash-completion/completions/pls
```

2. **Or directly in home directory**:
```bash
cp pls_completion.bash ~/.bash_completion.d/pls
# Add to ~/.bashrc if ~/.bash_completion.d exists:
# for completion in ~/.bash_completion.d/*; do source "$completion"; done
```

3. **System-wide (requires sudo)**:
```bash
sudo cp pls_completion.bash /etc/bash_completion.d/pls
```

### Zsh

1. **Using XDG Base Directory (Recommended)**:
```bash
mkdir -p ~/.local/share/zsh/site-functions
cp pls_completion.zsh ~/.local/share/zsh/site-functions/_pls
```

2. **Manual (add to ~/.zshrc)**:
```bash
mkdir -p ~/.zsh/completions
cp pls_completion.zsh ~/.zsh/completions/_pls
# In ~/.zshrc, add before completion initialization:
fpath=(~/.zsh/completions $fpath)
```

3. **System-wide (requires sudo)**:
```bash
sudo cp pls_completion.zsh /usr/local/share/zsh/site-functions/_pls
```

### Fish

1. **Using XDG Config (Recommended)**:
```bash
mkdir -p ~/.config/fish/completions
cp pls_completion.fish ~/.config/fish/completions/pls.fish
```

2. **System-wide (requires sudo)**:
```bash
sudo cp pls_completion.fish /usr/local/share/fish/vendor_completions.d/pls.fish
```

## Usage

After installation, completions are automatically available. Start typing and press **Tab**:

```bash
# Complete flags
pls --<TAB>
# Shows: --debug  --fast  --help  --verbose  --version

# Complete shells
pls "find files" <TAB>
# Shows shell options after subcommand

# After installation, restart your shell:
exec $SHELL
```

## Supported Completions

### Flags
- `--help` / `-h` - Show help
- `--version` / `-v` - Show version
- `--debug` - Enable debug mode
- `--verbose` - Enable verbose mode
- `--fast` / `-f` - Use fast mode

### Shell Names
- `bash`
- `zsh`
- `fish`

## Troubleshooting

**Completions not working after installation?**

1. **Restart your shell**:
   ```bash
   exec $SHELL
   ```

2. **Check if completion file is in correct location**:
   ```bash
   # Bash
   cat ~/.local/share/bash-completion/completions/pls
   
   # Zsh (check fpath)
   echo $fpath | tr ' ' '\n'
   
   # Fish
   cat ~/.config/fish/completions/pls.fish
   ```

3. **Verify syntax** (zsh/bash):
   ```bash
   bash -n pls_completion.bash
   ```

4. **Force reload** (zsh):
   ```bash
   rm -f ~/.zcompdump
   exec zsh
   ```

## Contributing

To improve completions:
1. Edit the relevant completion file
2. Test with your shell
3. Submit a PR with improvements

## Notes

- Bash completion requires `bash-completion` package on some distributions
- Zsh completion is built-in; no additional packages needed
- Fish completion requires Fish 2.6.0 or newer
