#!/usr/bin/env bash
#
# Renders the "an agent needs me" dot on workspace pills — i.e. a Ghostty window
# where Claude Code has finished and is waiting on you. Owns ONLY the `label`
# layer of each space.<id> item (aerospace.sh owns icon/background/visibility),
# so the two scripts set disjoint properties and never clobber each other.
#
# Driven by two events (see sketchybarrc):
#   agent_ready_change          fired by agent-ready-hook.sh when state changes
#   aerospace_workspace_change  so focusing a workspace clears its dot
#
# State (written by the hook): $STATE/ready/<session-id> contains the AeroSpace
# window-id of a session that's waiting on you. We re-resolve window -> current
# workspace here, so a window that moved is still attributed correctly.

AERO=/opt/homebrew/bin/aerospace
STATE="${XDG_CACHE_HOME:-$HOME/.cache}/agent-ready"
mkdir -p "$STATE/ready"

THEME="$HOME/.config/sketchybar/theme.env"
[ -f "$THEME" ] && source "$THEME"
: "${NOTIF_COLOR:=0xffe06c75}" "${GHOSTTY_FONT:=Menlo}"

WORKSPACES=(1 2 3 4 5 6 7 8 9 "꩜" "☌")

focused="$("$AERO" list-workspaces --focused 2>/dev/null)"

# window-id -> workspace, one aerospace call.
declare -A win2ws
while IFS='|' read -r wid ws; do
  [ -n "$wid" ] && win2ws["$wid"]="$ws"
done < <("$AERO" list-windows --all --format '%{window-id}|%{workspace}' 2>/dev/null)

# Which workspaces hold a ready agent? Focusing a workspace counts as "seen", so
# we drop those sessions. Sessions whose window has vanished are also dropped.
declare -A hot
for f in "$STATE"/ready/*; do
  [ -e "$f" ] || continue
  wid="$(cat "$f" 2>/dev/null)"
  ws="${win2ws[$wid]:-}"
  # Window not in the current list (closed, or a transient query miss): just
  # skip it. Real cleanup is the hook's SessionEnd — don't drop the flag on a
  # momentary miss.
  if [ -z "$ws" ]; then continue; fi
  if [ "$ws" = "$focused" ]; then rm -f "$f"; continue; fi # you're looking at it
  hot["$ws"]=1
done

# The dot is a permanently-reserved label on each pill (see sketchybarrc), so we
# only flip its color — transparent when idle, red when ready. Width never
# changes, so toggling a badge never shifts any other label.
for sid in "${WORKSPACES[@]}"; do
  if [ -n "${hot[$sid]:-}" ]; then
    sketchybar --set "space.$sid" label.color="$NOTIF_COLOR"
  else
    sketchybar --set "space.$sid" label.color=0x00000000
  fi
done
