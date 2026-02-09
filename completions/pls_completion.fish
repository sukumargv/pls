#!/usr/bin/env fish
# Fish completion for pls
# Installation:
#   mkdir -p ~/.config/fish/completions
#   cp completions/pls_completion.fish ~/.config/fish/completions/pls.fish

# Flags
complete -c pls -s h -l help -d "Show help message"
complete -c pls -s v -l version -d "Show version"
complete -c pls -l debug -d "Enable debug output with detailed information"
complete -c pls -l verbose -d "Enable verbose output"
complete -c pls -s f -l fast -d "Fast mode: skip context analysis and generate immediately"

# Shell arguments
complete -c pls -n "__fish_seen_subcommand_from bash zsh fish" -a "bash" -d "Target Bash shell"
complete -c pls -n "__fish_seen_subcommand_from bash zsh fish" -a "zsh" -d "Target Zsh shell"
complete -c pls -n "__fish_seen_subcommand_from bash zsh fish" -a "fish" -d "Target Fish shell"
