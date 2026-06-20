#!/usr/bin/env bash
#
# Highlights the focused workspace pill; dims the rest. Empty workspaces are
# hidden unless they hold windows or are focused.
# Queries AeroSpace directly so it works regardless of event-env plumbing.
# $NAME is "space.<id>"; the id is everything after the first dot.

AERO=/opt/homebrew/bin/aerospace

# Colors come from the Ghostty-derived theme (regenerated on sketchybar reload).
THEME="$HOME/.config/sketchybar/theme.env"
[ -f "$THEME" ] && source "$THEME"
: "${FOCUSED_BG:=0xffe1e3e4}" "${FOCUSED_FG:=0xff1e1e2e}" "${DIM_FG:=0xffc8ccd6}"

sid="${NAME#space.}"
focused="$($AERO list-workspaces --focused)"

if [ "$sid" = "$focused" ]; then
  sketchybar --set "$NAME" \
    drawing=on \
    background.drawing=on \
    background.color=$FOCUSED_BG \
    icon.color=$FOCUSED_FG
  exit 0
fi

# Unfocused: show the pill only if the workspace holds windows. Empty
# workspaces (named or numbered) are hidden — the focused one always shows
# (handled above), so you can still reach an empty one via its keybind.
vis=on
$AERO list-windows --workspace "$sid" 2>/dev/null | grep -q . || vis=off

sketchybar --set "$NAME" \
  drawing=$vis \
  background.drawing=off \
  icon.color=$DIM_FG
