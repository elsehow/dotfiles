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
| `bin/`       | `~/.local/bin/ghostty-theme`                                    |
| `ghostty/`   | `~/Library/Application Support/com.mitchellh.ghostty/config`     |

Restow after editing/pulling: `cd ~/dotfiles && stow --restow aerospace sketchybar bin ghostty`

## How the theming works

- `sketchybar/.config/sketchybar/generate-theme.sh` reads `ghostty +show-config`
  and writes `theme.env` (font, bar color/opacity/blur, accent + **border** colors).
  `theme.env` is **generated** — gitignored, regenerated on every reload.
- `sketchybarrc` sources `theme.env`, styles the bar, and re-tints the live
  `borders` daemon — so a reload propagates the theme to the bar *and* window borders.
- `~/.local/bin/ghostty-theme "<name>"` is the single knob: writes the theme into
  the Ghostty config, reloads live terminals, and reloads sketchybar (which
  re-derives the palette). Run `ghostty-theme --list` to browse, `--current` to check.

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
