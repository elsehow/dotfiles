#!/usr/bin/env bash
#
# Source-of-truth hook for the "this agent needs me" workspace dots.
#
# Wired into Claude Code's GLOBAL hooks (~/.claude/settings.json) so it fires for
# every Claude Code session in any Ghostty window. Invoked with one arg naming
# the moment:
#   start  | submit  -> you are interacting with this window now (it is focused),
#                       so pin session -> AeroSpace window-id and clear any
#                       pending "ready" flag.
#   ready            -> agent finished (Stop) or wants input/permission
#                       (Notification): flag this session ready.
#   end              -> session ended: forget it.
#
# The hook JSON payload arrives on stdin; we only need .session_id. Window->
# workspace is re-resolved at render time (agent-ready.sh), so a window that
# moved workspaces is still tracked correctly.
#
# No polling, no Accessibility/Automation permissions — just the aerospace CLI.

AERO=/opt/homebrew/bin/aerospace
SKETCHYBAR=/opt/homebrew/bin/sketchybar
STATE="${XDG_CACHE_HOME:-$HOME/.cache}/agent-ready"
mkdir -p "$STATE/win" "$STATE/ready"

mode="${1:-}"
payload="$(cat 2>/dev/null)"
sid="$(printf '%s' "$payload" | jq -r '.session_id // empty' 2>/dev/null)"
[ -z "$sid" ] && exit 0

# The OS-focused window's AeroSpace id (the window the user is typing into).
focused_win() { "$AERO" list-windows --focused --format '%{window-id}' 2>/dev/null | head -n1; }

case "$mode" in
  start|submit)
    w="$(focused_win)"; [ -n "$w" ] && printf '%s' "$w" > "$STATE/win/$sid"
    rm -f "$STATE/ready/$sid"
    ;;
  ready)
    # Use the window we pinned while focused; fall back to the focused window if
    # we somehow never saw a start/submit for this session.
    w="$(cat "$STATE/win/$sid" 2>/dev/null)"; [ -z "$w" ] && w="$(focused_win)"
    [ -n "$w" ] && printf '%s' "$w" > "$STATE/ready/$sid"
    ;;
  end)
    rm -f "$STATE/win/$sid" "$STATE/ready/$sid"
    ;;
esac

"$SKETCHYBAR" --trigger agent_ready_change 2>/dev/null || true
exit 0
