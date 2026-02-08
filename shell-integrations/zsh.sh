# pls integration for Zsh

pls() {
    local debug_flag=""
    local version_flag=""
    local fast_flag=""
    local -a prompt_parts

    for arg in "$@"; do
        case "$arg" in
            --debug) debug_flag="--debug" ;;
            -v|--version) version_flag="$arg" ;;
            -f|--fast) fast_flag="$arg" ;;
            *) prompt_parts+=("$arg") ;;
        esac
    done

    if [[ -n "$version_flag" && ${#prompt_parts[@]} -eq 0 ]]; then
        pls-engine "$version_flag"
        return 0
    fi

    if [[ ${#prompt_parts[@]} -eq 0 ]]; then
        echo "Usage: pls [--debug] [--fast | -f] [--version | -v] <your natural language command>" >&2
        return 1
    fi

    local user_prompt="${(j: :)prompt_parts}"
    local suggested_cmd

    suggested_cmd="$(pls-engine ${debug_flag} ${fast_flag} "$user_prompt" "zsh")"

    if [[ -n "$suggested_cmd" ]]; then
        print -s -- "$suggested_cmd"
        echo
        local final_cmd="$suggested_cmd"
        vared -p "$(print -P '%F{green}>%f ')" final_cmd
        if [[ -n "$final_cmd" ]]; then
            print -s -- "$final_cmd"
            eval "$final_cmd"
        fi
    else
        return 0
    fi
}
