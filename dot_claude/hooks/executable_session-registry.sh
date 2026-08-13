#!/usr/bin/env bash
# Registry of Claude Code sessions: one JSON file per session under
# ~/.claude/sessions-registry/. Driven by hooks in ~/.claude/settings.json:
#   SessionStart     -> session-registry.sh start
#   UserPromptSubmit -> session-registry.sh prompt
#   SessionEnd       -> session-registry.sh end
# Read the registry with: claude-sessions (~/bin/claude-sessions)
#
# Hook stdout is injected into the model context, so stay silent.
exec >/dev/null
set -u

ACTION="${1:-}"
REG_DIR="${CLAUDE_SESSION_REGISTRY_DIR:-$HOME/.claude/sessions-registry}"
mkdir -p "$REG_DIR" 2>/dev/null || exit 0

INPUT="$(cat 2>/dev/null || true)"
SID="$(printf '%s' "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)"
[ -z "$SID" ] && exit 0
F="$REG_DIR/$SID.json"
NOW="$(date -Iseconds)"
CWD="$(printf '%s' "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)"

# The hook shell is a child of the claude process; walk up to find its PID.
find_claude_pid() {
  local p=$PPID i
  for i in 1 2 3 4 5 6; do
    case "$p" in ''|0|1) return 0 ;; esac
    [ -r "/proc/$p/cmdline" ] || return 0
    if tr '\0' ' ' < "/proc/$p/cmdline" 2>/dev/null | grep -q claude; then
      printf '%s' "$p"
      return 0
    fi
    p="$(awk '{print $4}' "/proc/$p/stat" 2>/dev/null)"
  done
}
PID="$(find_claude_pid || true)"

update() { # update JQ_FILTER [--arg k v ...] — in-place edit of $F
  local filter="$1"; shift
  local tmp
  tmp="$(mktemp "$REG_DIR/.tmp.XXXXXX")" || exit 0
  if jq "$@" "$filter" "$F" >"$tmp" 2>/dev/null; then
    mv "$tmp" "$F"
  else
    rm -f "$tmp"
  fi
}

create_entry() { # create_entry DESCRIPTION
  jq -n --arg sid "$SID" --arg cwd "$CWD" --arg pid "${PID:-}" \
    --arg ts "$NOW" --arg d "$1" \
    '{session_id:$sid, cwd:$cwd, pid:$pid, started:$ts,
      last_activity:$ts, description:$d}' >"$F" 2>/dev/null
}

case "$ACTION" in
  start)
    if [ -f "$F" ]; then
      # resume of a known session: keep started/description, clear ended mark
      update 'del(.ended, .end_reason) | .pid=$pid | .last_activity=$ts
              | .cwd=(if $cwd=="" then .cwd else $cwd end)' \
        --arg pid "${PID:-}" --arg cwd "$CWD" --arg ts "$NOW"
    else
      create_entry ""
    fi
    # GC: drop cleanly-ended entries untouched for 30+ days
    find "$REG_DIR" -name '*.json' -mtime +30 \
      -exec grep -l '"ended"' {} \; 2>/dev/null | xargs -r rm -f
    ;;
  prompt)
    D="$(printf '%s' "$INPUT" | jq -r '.prompt // empty' 2>/dev/null \
        | tr '\n\t' '  ' | head -c 200 | sed 's/[[:space:]]*$//')"
    if [ -f "$F" ]; then
      update 'del(.ended, .end_reason) | .last_activity=$ts
              | .pid=(if $pid=="" then .pid else $pid end)
              | .description=(if (.description // "")=="" then $d else .description end)' \
        --arg ts "$NOW" --arg pid "${PID:-}" --arg d "$D"
    else
      # session predates the registry hooks: register it on first prompt
      create_entry "$D"
    fi
    ;;
  end)
    # Mark ended instead of deleting: a hard shutdown must never wipe the
    # registry, and this keeps "what was open before reboot" answerable.
    REASON="$(printf '%s' "$INPUT" | jq -r '.reason // "unknown"' 2>/dev/null)"
    [ -f "$F" ] && update '.ended=$ts | .end_reason=$r | .pid=""' \
      --arg ts "$NOW" --arg r "$REASON"
    ;;
esac
exit 0
