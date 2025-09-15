# My Dotfiles

A comprehensive dotfiles repository for managing configuration files and system packages across multiple machines using GNU Stow.

<!--toc:start-->

- [My Dotfiles](#my-dotfiles)
  - [Quick Start](#quick-start)
  - [Full Machine Restoration](#full-machine-restoration)
    - [Prerequisites](#prerequisites)
    - [Step 1: Clone Repository](#step-1-clone-repository)
    - [Step 2: Install Packages](#step-2-install-packages)
    - [Step 3: Apply Dotfiles](#step-3-apply-dotfiles)
    - [Step 4: Configure System](#step-4-configure-system)
  - [Managing Dotfiles](#managing-dotfiles)
    - [Adding New Dotfiles](#adding-new-dotfiles)
    - [Updating Package Lists](#updating-package-lists)
    - [Syncing Changes](#syncing-changes)
  - [Systems](#systems)
  - [Configuration Overview](#configuration-overview)
  - [Troubleshooting](#troubleshooting)
  <!--toc:end-->

## Quick Start

If you just want to apply existing configurations:

```bash
# Clone the repository
git clone <your-repo-url> ~/workspace/dotfiles
cd ~/workspace/dotfiles

# For Arch Linux (Nickel)
yay -S --needed - < nickel/pkglist.txt
stow -t ~ nickel

# For macOS (Silver)
brew install --force $(cat silver/pkglist.txt)
stow -t ~ silver
```

## Full Machine Restoration

### Prerequisites

**For Arch Linux:**

- Fresh Arch Linux installation
- `yay` AUR helper installed
- `git` and `stow` packages

**For macOS:**

- macOS Sequoia
- Homebrew installed (if using brew packages)
- `stow` installed via Homebrew

### Step 1: Clone Repository

```bash
# Create workspace directory
mkdir -p ~/workspace
cd ~/workspace

# Clone your dotfiles repository
git clone <your-repo-url> dotfiles
cd dotfiles
```

### Step 2: Install Packages

**For Nickel (Arch Linux):**

```bash
# Install all packages from the package list
# The --needed flag skips already installed packages
yay -S --needed - < nickel/pkglist.txt
```

**For Silver (macOS):**

```bash
# Install all packages from the package list
brew install --force $(cat silver/pkglist.txt)
```

### Step 3: Apply Dotfiles

```bash
# Apply configurations for your specific system
# This will create symlinks from your home directory to the dotfiles

# For Nickel (Arch Linux)
stow -t ~ nickel

# For Silver (macOS)
stow -t ~ silver

# To see what would be linked without actually doing it:
# stow -n -t ~ nickel  # dry run
```

### Step 4: Configure System

**Post-installation steps:**

1. **Shell Configuration:**
   - Restart your terminal or run `source ~/.zshrc`
   - Zsh should now use your custom configuration with themes and plugins

2. **Hyprland (Nickel only):**
   - Your Hyprland window manager configuration will be active
   - Includes custom keybindings, animations, and window rules
   - Waybar, dunst, and other components are pre-configured

3. **Neovim:**
   - Your Neovim configuration with plugins will be available
   - Run `:checkhealth` in Neovim to verify everything is working

4. **Git:**
   - Your Git configuration is automatically applied
   - Verify with `git config --list`

## Managing Dotfiles

### Adding New Dotfiles

To add a new configuration file to your dotfiles:

```bash
# 1. Move the file to the appropriate system directory
mv ~/.config/new-app/config ~/workspace/dotfiles/nickel/.config/new-app/config

# 2. Create the symlink using stow
cd ~/workspace/dotfiles
stow -t ~ nickel

# 3. Commit the changes
git add .
git commit -m "Add new-app configuration"
git push
```

### Updating Package Lists

When you install new packages, update your package list:

```bash
# For Arch Linux (Nickel)
yay -Qqe > nickel/pkglist.txt

# Commit the updated package list
git add nickel/pkglist.txt
git commit -m "Update package list"
git push
```

### Syncing Changes

To sync changes across machines:

```bash
# Pull latest changes
git pull

# Re-apply configurations (handles new files)
stow -R -t ~ nickel  # or silver

# Install any new packages
yay -S --needed - < nickel/pkglist.txt  # For Arch Linux
brew install --force $(cat silver/pkglist.txt)  # For macOS
```

## Systems

### Nickel

**Hardware:** ThinkPad T14 Gen 1  
**OS:** Arch Linux  
**DE/WM:** Hyprland  
**Terminal:** Alacritty  
**Shell:** Zsh with custom configuration

**Key Components:**

- Hyprland window manager with custom animations and workflows
- Waybar status bar with custom styling
- Dunst notification system
- Rofi application launcher
- Neovim with extensive plugin configuration
- Custom Zsh setup with starship prompt

### Silver

**Hardware:** MacBook (Main macOS Laptop)
**OS:** macOS Sequoia
**Terminal:** Ghostty
**Shell:** Zsh

**Key Components:**

- Neovim configuration optimized for macOS
- tmux configuration
- Git configuration
- Custom Zsh setup
- Package management via Homebrew with pkglist.txt

## Configuration Overview

```
dotfiles/
├── nickel/              # Arch Linux configurations
│   ├── .config/
│   │   ├── hypr/        # Hyprland WM config
│   │   ├── waybar/      # Status bar config
│   │   ├── nvim/        # Neovim configuration
│   │   ├── zsh/         # Zsh configuration
│   │   ├── alacritty/   # Terminal config
│   │   └── dunst/       # Notifications
│   ├── .zshrc           # Main zsh config
│   ├── .gitconfig       # Git configuration
│   ├── .tmux.conf       # tmux configuration
│   └── pkglist.txt      # Arch packages list
├── silver/              # macOS configurations
│   ├── .config/
│   │   ├── nvim/        # Neovim for macOS
│   │   ├── ghostty/     # Terminal config
│   │   └── btop/        # System monitor
│   ├── .zshrc           # Zsh for macOS
│   ├── .gitconfig       # Git config
│   ├── .tmux.conf       # tmux config
│   └── pkglist.txt      # Homebrew packages list
└── README.md            # This file
```

## Troubleshooting

**Stow conflicts:**

```bash
# If stow complains about existing files, backup and remove them:
mv ~/.zshrc ~/.zshrc.backup
stow -t ~ nickel
```

**Permission issues:**

```bash
# Make sure you own the target directories
sudo chown -R $USER:$USER ~/.config
```

**Missing dependencies:**

```bash
# Verify all packages installed correctly
yay -Qqe | grep -f nickel/pkglist.txt
```

**Git configuration:**

```bash
# Update git configuration if needed
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```
