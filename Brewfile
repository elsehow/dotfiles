# Brewfile — dependencies for the aerospace + sketchybar + ghostty rice.
# Install everything with:  brew bundle --file ~/dotfiles/Brewfile
#
# Taps
tap "felixkratz/formulae"   # sketchybar, borders
tap "nikitabobko/tap"       # aerospace

# Window manager + bar + borders
cask "aerospace"            # tiling window manager (~/.aerospace.toml)
brew "sketchybar"           # menu bar (~/.config/sketchybar/)
brew "borders"              # JankyBorders — window borders (driven from theme.env)

# Terminal
cask "ghostty"              # config in ~/Library/Application Support/com.mitchellh.ghostty/

# Fonts
cask "font-inconsolata"     # terminal + bar font
cask "font-hack-nerd-font"  # Nerd Font for the battery glyphs (laptops)

# Tooling
brew "stow"                 # symlinks these dotfiles into place (bootstrap.sh)

# Optional: live-design GLSL shaders to port into theme-texture. NOT used by the
# pipeline (it can't render headless on macOS — it always opens a window).
# cask "glslviewer"
#
# `theme-wallpaper --texture` needs numpy + Pillow in your python3. They're NOT
# brew formulae here (python.org framework + pip), so bootstrap.sh installs them
# with pip. Solid mode (the default) is pure-stdlib and needs neither.
