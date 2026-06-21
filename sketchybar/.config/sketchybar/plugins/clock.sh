#!/usr/bin/env bash
# Clock — monospace time in the Ghostty font (icon disabled in sketchybarrc).
sketchybar --set "$NAME" label="$(date '+%a %b %-d %H:%M')"
