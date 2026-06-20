# dotfiles

macOS desktop rice: [AeroSpace](https://github.com/nikitabobko/AeroSpace) tiling
WM + [sketchybar](https://github.com/FelixKratz/SketchyBar) menu bar +
[JankyBorders](https://github.com/FelixKratz/JankyBorders) +
[Ghostty](https://ghostty.org) terminal — all themed from a single source.

The bar, window borders, and terminal share one palette + font, derived live
from the Ghostty theme. Switch the whole desktop look with one command.

## New machine

```sh
git clone <this-repo> ~/dotfiles
~/dotfiles/bootstrap.sh
```

`bootstrap.sh` installs dependencies (`brew bundle`), symlinks the configs into
place (`stow`), and starts the services. Then log out/in (or launch AeroSpace).

> Ghostty stores its config under `~/Library/Application Support/com.mitchellh.ghostty/`.
> That folder is created when Ghostty first launches; `bootstrap.sh` also `mkdir -p`s
> it so stow can link the config on a truly fresh machine.

## Layout (GNU Stow packages)

Each top-level dir is a Stow package whose tree mirrors `$HOME`:

| Package      | Links to                                                        |
| ------------ | --------------------------------------------------------------- |
| `aerospace/` | `~/.aerospace.toml`                                             |
| `sketchybar/`| `~/.config/sketchybar/` (rc, theme generator, plugins)          |
| `bin/`       | `~/.local/bin/` — `set-theme`, `ws-label`, `theme-wallpaper`, `theme-texture` |
| `ghostty/`   | `~/Library/Application Support/com.mitchellh.ghostty/config`     |

Restow after editing/pulling: `cd ~/dotfiles && stow --restow aerospace sketchybar bin ghostty`

## How the theming works

- `sketchybar/.config/sketchybar/generate-theme.sh` reads `ghostty +show-config`
  and writes `theme.env` (font, bar color/opacity/blur, accent + **border** colors).
  `theme.env` is **generated** — gitignored, regenerated on every reload.
- `sketchybarrc` sources `theme.env`, styles the bar, and re-tints the live
  `borders` daemon — so a reload propagates the theme to the bar *and* window borders.
- `~/.local/bin/set-theme "<name>"` is the single knob: writes the theme into
  the Ghostty config, reloads live terminals, reloads sketchybar (which re-derives
  the palette), and repaints the desktop wallpaper. Browse with `--list`,
  `--current` to check, `--random [light|dark]` to roll one (light/dark filtered
  by reading each theme file's background luminance), `--opacity <0..1>` to
  set terminal background transparency (default 1 = opaque; pass alone to
  re-apply the current theme at a new opacity), and `--style <mesh|contour|flat>`
  to pick the wallpaper look (see *Desktop wallpaper* below).
- Config writes go *through* the stow symlink (never `mv` over it), so switching
  themes keeps `~/Library/.../ghostty/config` linked to the repo.

## Desktop wallpaper (theme-driven)

`set-theme` repaints the desktop on every theme change via `theme-wallpaper`
(**texture by default**; `export THEME_WALLPAPER_MODE=--solid` for a flat color):

- **Solid (default)** — the theme background *darkened* (×0.65), so tiling gaps
  read as a recessed gutter and windows float. Light themes → warm "paper" gray;
  dark themes → deep gutter. Pure-stdlib, works everywhere.
  `theme-wallpaper "#1e1e2e"` forces an explicit color (exact bg = seamless).
- **Texture (`theme-wallpaper --texture [style]`)** — a subtle procedural
  wallpaper rendered from the theme's 16-color ANSI palette, in one of six
  **styles** (calmest → most assertive):
  - `flat` — a single soft corner-to-corner gradient with a whisper of accent
    glow. The calmest; closest to a plain matte wall.
  - `dot` — a fine regular dot grid a touch off the base (perfboard / graph-
    paper). Minimal and static; dots move toward contrast so light themes show.
  - `mesh` (default) — soft inverse-distance gradient. Bright/dark/accent pools
    are pushed to the rim with a center vignette (so windows sit on calm ground),
    colors mix in linear-light (no muddy brown between accents), and a luminance-
    aware darken keeps light "paper" themes papery instead of crushing them grey.
  - `lowpoly` — flat-shaded triangle facets (jittered grid, no scipy) shaded from
    a smooth field with a faint accent tint. Geometric but calm.
  - `contour` — topographic iso-lines in an accent over the base. On-brand for a
    terminal rice; light themes read as a cream contour map.
  - `halftone` — overlapping ben-day dot screens in two accents at print angles.
    The most assertive — a riso/print look.

  Accent choice is shuffled per-theme, so a style doesn't always grab the same
  palette slot (e.g. `contour` isn't perpetually red) while staying stable for a
  given theme. The "art" lives in `theme-texture` (a numpy/Pillow script) — each
  style is a `render_<name>()`; add one and register it in `STYLES`. Prototype
  shaders in glslViewer/Shadertoy and port the math in. Needs numpy + Pillow (see
  Brewfile); falls back to solid if absent.

`set-theme` (incl. `--random`) uses texture by default. Roll the look with
`set-theme --style contour` (or `mesh`/`flat`; pass alone to re-skin the current
theme). Env knobs: `export THEME_WALLPAPER_MODE=--solid` for a flat color,
`export THEME_WALLPAPER_STYLE=contour` to change the default texture style, and
`export THEME_WALLPAPER_SIZE=5120x2160` to set output size (default `7680x3240`).

## Per-machine adaptation

One config runs on every Mac; the scripts adapt at runtime instead of branching
per host:

- **Battery** appears in the bar only on machines with an internal battery
  (laptops). `sketchybarrc` gates it behind `pmset -g batt`, so desktops
  (Mac Studio, Mac mini) simply don't show it. The glyphs need a Nerd Font
  (`font-hack-nerd-font`, in the Brewfile).

## Knobs

- Bar vertical float: `BAR_GAP_TOP` in `sketchybarrc` (keep `outer.top` in
  `~/.aerospace.toml` = `BAR_GAP_TOP*2 + BAR_HEIGHT`).
- Border width: `width=` in `sketchybarrc` (and the matching login line in
  `~/.aerospace.toml`).
- Opacity / blur match to Ghostty: `OPACITY_OVERRIDE` / `BLUR_OVERRIDE` near the
  top of `generate-theme.sh`.
