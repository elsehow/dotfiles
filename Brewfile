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
