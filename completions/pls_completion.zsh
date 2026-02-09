#compdef pls
# Zsh completion for pls
# Installation:
#   mkdir -p ~/.local/share/zsh/site-functions
#   cp completions/pls_completion.zsh ~/.local/share/zsh/site-functions/_pls
#   OR: add ~/.local/share/zsh/site-functions to fpath in ~/.zshrc

_pls() {
    local -a _pls_opts _shells
    
    _pls_opts=(
        '(--help)-h[Show help message]'
        '(--version -v)--version[Show version]'
        '(-v)--version[Show version]'
        '--debug[Enable debug output]'
        '--verbose[Enable verbose output]'
        '(--fast)-f[Fast mode: skip context analysis]'
        '(-f)--fast[Fast mode: skip context analysis]'
    )
    
    _shells=(
        'bash:Bash shell'
        'zsh:Zsh shell'
        'fish:Fish shell'
    )
    
    _arguments -s \
        $_pls_opts \
        '*::shell:(($_shells))' \
        '*::prompt:'
}

_pls "$@"
