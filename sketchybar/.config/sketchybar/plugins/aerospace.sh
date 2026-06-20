#!/usr/bin/env bash
#
# Highlights the focused workspace pill; dims the rest. Numbered scratch
# workspaces (single digit) are hidden unless they hold windows or are focused.
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

# Unfocused. Numbered scratch workspaces show only when non-empty.
vis=on
case "$sid" in
  [0-9])
    $AERO list-windows --workspace "$sid" 2>/dev/null | grep -q . || vis=off
    ;;
esac

sketchybar --set "$NAME" \
  drawing=$vis \
  background.drawing=off \
  icon.color=$DIM_FG
