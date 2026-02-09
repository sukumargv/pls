#!/usr/bin/env bash
# Bash completion for pls
# Installation:
#   mkdir -p ~/.local/share/bash-completion/completions
#   cp completions/pls_completion.bash ~/.local/share/bash-completion/completions/pls
#   OR: source completions/pls_completion.bash in ~/.bashrc

_pls_completion() {
    local cur prev opts shells
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Available options
    opts="--debug --verbose --fast --version -f -v -h --help"
    shells="bash zsh fish"
    
    # Complete flags
    if [[ ${cur} == -* ]]; then
        COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
        return 0
    fi
    
    # Complete shell names (last argument)
    if [[ ${COMP_CWORD} -gt 1 ]]; then
        local last_opt="${COMP_WORDS[COMP_CWORD-1]}"
        # If the last item looks like a shell name context... just offer shells
        if [[ ! "${last_opt}" =~ ^- ]]; then
            COMPREPLY=($(compgen -W "${shells}" -- "${cur}"))
            return 0
        fi
    fi
    
    return 0
}

complete -o bashdefault -o default -o nospace -F _pls_completion pls
