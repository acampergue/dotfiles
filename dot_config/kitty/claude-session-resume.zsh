# Claude Code session pinning for kitty session restore.
#
# kitty (save_as_session --use-foreground-process) saves the command line as
# typed at the prompt and replays it through the shell on layout restore.
# A bare `claude` would therefore start a *new* session on restore. Fix:
#
#  1. A zle accept-line hook appends an explicit `--session-id <uuid>` to any
#     typed `claude` command that has no session flags, so the session's
#     identity is part of the saved command line.
#  2. A `claude` wrapper function turns `--session-id <id>` into
#     `--resume <id>` when that session already exists on disk — which is
#     exactly what happens when kitty replays the line after a restore
#     (and when re-running the line from shell history).

_claude_session_pin_accept_line() {
    if [[ "$BUFFER" == claude([[:space:]]*|) ]]; then
        case " $BUFFER " in
            *" --session-id "*|*" --resume "*|*" -r "*|*" --continue "*|*" -c "*|\
            *" --print "*|*" -p "*|*" --help "*|*" -h "*|*" --version "*|*" -v "*|\
            *" mcp "*|*" update "*|*" doctor "*|*" install "*|*" setup-token "*|*" migrate-installer "*|\
            *"|"*|*";"*|*"&"*|*">"*|*"<"*)
                ;;
            *)
                BUFFER="$BUFFER --session-id $(uuidgen)"
                ;;
        esac
    fi
    zle .accept-line
}
zle -N accept-line _claude_session_pin_accept_line

claude() {
    local -a args
    args=("$@")
    local i
    for (( i = 1; i < ${#args[@]}; i++ )); do
        if [[ "${args[i]}" == --session-id && -n "${args[i+1]}" ]]; then
            local -a existing
            existing=( ~/.claude/projects/*/"${args[i+1]}".jsonl(N) )
            if (( ${#existing[@]} )); then
                args[i]="--resume"
            fi
            break
        fi
    done
    command claude "${args[@]}"
}
