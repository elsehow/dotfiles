#!/usr/bin/env bash
#
# bootstrap.sh — set up this rice on a fresh Mac in one command.
#
#   git clone <this repo> ~/dotfiles && ~/dotfiles/bootstrap.sh
#
# Steps:
#   1. install Homebrew dependencies from the Brewfile (tap, aerospace,
#      sketchybar, borders, ghostty, fonts, stow)
#   2. symlink the configs into place with GNU Stow
#   3. start the sketchybar service and (re)load aerospace
#
# Idempotent: safe to re-run. Re-run after pulling new changes to restow.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES"

# ── 1. Homebrew + dependencies ───────────────────────────────────────────────
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it first: https://brew.sh" >&2
  exit 1
fi
echo "==> brew bundle (installing dependencies)"
brew bundle --file "$DOTFILES/Brewfile"

# ── 2. Symlink configs with Stow ─────────────────────────────────────────────
# Each top-level dir here is a Stow "package" whose tree mirrors $HOME.
# Stow only touches files it owns; pre-existing real files cause a conflict
# (move them aside first if so). The ghostty package's parent dirs under
# ~/Library/Application Support/ are created by Ghostty on first launch — if
# missing, launch Ghostty once (or `mkdir -p`) before stowing the ghostty pkg.
echo "==> stow (symlinking configs into \$HOME)"
mkdir -p "$HOME/.config" "$HOME/.local/bin" \
         "$HOME/Library/Application Support/com.mitchellh.ghostty"
stow --target="$HOME" --restow aerospace sketchybar bin ghostty

# ── 2b. Optional: texture-wallpaper deps ─────────────────────────────────────
# `theme-wallpaper --texture` renders a procedural wallpaper with numpy + Pillow.
# Solid mode (default) is pure-stdlib, so this is best-effort — don't fail setup.
echo "==> pip install numpy + Pillow (for theme-wallpaper --texture; optional)"
python3 -m pip install --quiet --user numpy pillow 2>/dev/null \
  || echo "    (skipped — texture mode will fall back to solid until installed)"

# ── 3. Start services ────────────────────────────────────────────────────────
echo "==> starting sketchybar + reloading aerospace"
brew services start sketchybar >/dev/null 2>&1 || sketchybar --reload || true
aerospace reload-config 2>/dev/null || \
  echo "    (aerospace not running yet — it'll pick up the config at next launch)"

echo
echo "✔ Done. Log out/in (or launch AeroSpace) to start the window manager."
echo "  Switch themes with:  set-theme \"<theme name>\""
