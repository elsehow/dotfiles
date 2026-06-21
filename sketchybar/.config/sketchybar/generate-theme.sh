#!/usr/bin/env bash
#
# Derive a sketchybar palette + font from the LIVE Ghostty config, so the bar
# tracks Ghostty's theme/font automatically. Run by sketchybarrc on every
# (re)load; writes theme.env, which the bar and plugins source cheaply (no
# per-event ghostty calls).
#
# Robustness:
#  - reads `ghostty +show-config`, which resolves themes (real effective colors)
#  - validates the configured font through CoreText; if it isn't actually a
#    system family (e.g. config says "Inconsolas" but only "Inconsolata" is
#    installed), substitutes a real monospace fallback instead of letting
#    sketchybar silently fall back to Helvetica.
#  - falls back to dark defaults if Ghostty/CLI is unavailable.

GHOSTTY_BIN="/Applications/Ghostty.app/Contents/MacOS/ghostty"
OUT="$HOME/.config/sketchybar/theme.env"
FALLBACK_FONT="Inconsolata"   # installed monospace; closest to the intended look

# ── Visual-match overrides (tune by eye) ─────────────────────────────────────
# Ghostty and sketchybar implement blur on different scales and composite
# opacity over different backdrops, so identical numbers do NOT look identical.
# To match the terminal, sketchybar usually needs LOWER opacity + HIGHER blur
# than Ghostty's literal values.
#
# Opacity now TRACKS Ghostty's background-opacity (so `set-theme --opacity`
# moves the bar too) instead of being pinned. OPACITY_BOOST shapes the match:
# it scales only the translucent gap below 1.0, so a fully-opaque terminal keeps
# a solid bar, while a translucent one gets a bar that reads a touch MORE
# translucent than Ghostty (>1 = lower than Ghostty; 1 = exact; "" also = exact).
OPACITY_BOOST="1.25"      # bar dips below Ghostty when translucent, solid at 1.0
BLUR_OVERRIDE="150"       # sketchybar blur radius     (Ghostty's is 100)

cfg="$("$GHOSTTY_BIN" +show-config 2>/dev/null || true)"
get() { printf '%s\n' "$cfg" | grep -m1 "^$1 = " | sed "s/^$1 = //" 2>/dev/null || true; }

req_font="$(get font-family)";        req_font="${req_font:-$FALLBACK_FONT}"
bg="$(get background)";               bg="${bg:-#1e1e2e}"
fg="$(get foreground)";               fg="${fg:-#cdd6f4}"
opacity="$(get background-opacity)";  opacity="${opacity:-1.0}"
blur="$(get background-blur)";        blur="${blur:-0}"

# Resolve the font through CoreText. If the requested family doesn't resolve to
# itself (i.e. isn't installed), use FALLBACK_FONT (or Menlo as last resort).
font="$(python3 - "$req_font" "$FALLBACK_FONT" <<'PY'
import ctypes, ctypes.util, sys
req, fb = sys.argv[1], sys.argv[2]
ct = ctypes.cdll.LoadLibrary(ctypes.util.find_library('CoreText'))
cf = ctypes.cdll.LoadLibrary(ctypes.util.find_library('CoreFoundation'))
cf.CFStringCreateWithCString.restype = ctypes.c_void_p
def family(name):
    s = cf.CFStringCreateWithCString(None, name.encode(), 0x08000100)
    ct.CTFontCreateWithName.restype = ctypes.c_void_p
    ct.CTFontCopyFamilyName.restype = ctypes.c_void_p
    f = ct.CTFontCreateWithName(ctypes.c_void_p(s), ctypes.c_double(14.0), None)
    r = ct.CTFontCopyFamilyName(ctypes.c_void_p(f))
    buf = ctypes.create_string_buffer(256); cf.CFStringGetCString(ctypes.c_void_p(r), buf, 256, 0x08000100)
    return buf.value.decode()
norm = lambda s: s.lower().replace(' ', '')
if norm(family(req)) == norm(req):
    print(req)
elif norm(family(fb)) == norm(fb):
    print(fb)
else:
    print('Menlo')
PY
)"

hexrgb() { echo "${1#\#}"; }
alpha()  { awk -v o="$1" 'BEGIN{a=int(o*255+0.5); if(a<0)a=0; if(a>255)a=255; printf "%02x",a}'; }

# Apply visual-match overrides over the Ghostty-derived values. The bar tracks
# Ghostty's opacity; OPACITY_BOOST deepens only the translucent gap below 1.0
# (boost 1 or empty → bar == Ghostty exactly; opacity 1.0 → bar stays solid).
opacity="$(awk -v o="$opacity" -v k="${OPACITY_BOOST:-1}" \
  'BEGIN{ v = 1 - (1 - o) * k; if (v < 0) v = 0; if (v > 1) v = 1; printf "%.4f", v }')"

BG_HEX="$(hexrgb "$bg")"; FG_HEX="$(hexrgb "$fg")"; A="$(alpha "$opacity")"
# The "agent needs me" dot uses the theme's red (ANSI palette color 1), so it
# pops against the monochrome bar while still belonging to the Ghostty theme.
red="$(printf '%s\n' "$cfg" | grep -m1 '^palette = 1=' | sed 's/^palette = 1=//')"
RED_HEX="$(hexrgb "${red:-#a31700}")"
case "$blur" in
  true)     blur=30 ;;
  false|"") blur=0 ;;
esac
[ -n "$BLUR_OVERRIDE" ] && blur="$BLUR_OVERRIDE"
[ "$blur" -gt 300 ] 2>/dev/null && blur=300   # sanity cap

cat > "$OUT" <<EOF
# Auto-generated from \`ghostty +show-config\` by generate-theme.sh — do not edit.
# Regenerated on every \`sketchybar --reload\`.
GHOSTTY_FONT="$font"
BAR_COLOR=0x${A}${BG_HEX}
BAR_BLUR=${blur}
ACCENT_FG=0xff${FG_HEX}
DIM_FG=0x99${FG_HEX}
FOCUSED_BG=0xff${FG_HEX}
FOCUSED_FG=0xff${BG_HEX}
# "Agent needs me" dot (agent-ready.sh) — the theme's red (palette color 1).
NOTIF_COLOR=0xff${RED_HEX}
# JankyBorders: active border = theme foreground; inactive = transparent.
BORDER_ACTIVE=0xff${FG_HEX}
BORDER_INACTIVE=0x00000000
EOF
