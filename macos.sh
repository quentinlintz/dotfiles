#!/usr/bin/env bash
# macOS system preferences. Not run by install.sh: this changes system state
# beyond dotfiles, so run it deliberately:  ./macos.sh
set -euo pipefail

echo "Applying macOS defaults…"

# ─── keyboard ─────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Hold-a-key repeats instead of showing the accent picker
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ─── finder ───────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"        # list view
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"        # search current folder
# No .DS_Store on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ─── dock ─────────────────────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false                       # don't reorder spaces

# ─── screenshots ──────────────────────────────────────────────────────────────
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ─── misc ─────────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write com.apple.LaunchServices LSQuarantine -bool false           # no "are you sure" on downloads
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

killall Finder Dock SystemUIServer 2>/dev/null || true

echo "Done. Some changes need a logout to take effect."
