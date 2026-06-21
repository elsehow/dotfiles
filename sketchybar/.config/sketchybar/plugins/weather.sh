#!/usr/bin/env bash
# Weather — outside temp via wttr.in (auto-detects location by IP, no API key).
# Set WEATHER_LOCATION in the env to override the pinned city.
LOC="${WEATHER_LOCATION:-Vancouver,BC}"
TEMP=$(curl -s --max-time 8 "wttr.in/${LOC}?format=%t&m" 2>/dev/null | tr -d '+')

# Network hiccup or empty response: keep the last label, don't blank the bar.
[ -z "$TEMP" ] && exit 0

sketchybar --set "$NAME" label="$TEMP"
