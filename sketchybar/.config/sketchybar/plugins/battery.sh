#!/usr/bin/env bash
# Battery: nerd-font glyph scales with charge; shows % label. Charging → bolt.

PCT=$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep -c 'AC Power')

[ -z "$PCT" ] && exit 0

if [ "$CHARGING" -eq 1 ]; then
  ICON="󰂄"   # charging
elif   [ "$PCT" -ge 90 ]; then ICON="󰁹"
elif [ "$PCT" -ge 70 ]; then ICON="󰂁"
elif [ "$PCT" -ge 50 ]; then ICON="󰁾"
elif [ "$PCT" -ge 30 ]; then ICON="󰁻"
elif [ "$PCT" -ge 10 ]; then ICON="󰁻"
else ICON="󰂎"
fi

sketchybar --set "$NAME" icon="$ICON" label="${PCT}%"
