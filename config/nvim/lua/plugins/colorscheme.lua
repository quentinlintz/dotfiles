-- Rosé Pine Moon, the same palette as ghostty, tmux, bat, btop, eza, fzf and
-- starship. See the theme table in the dotfiles README.
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon",
      styles = { italic = false }, -- MesloLGS Nerd Font has no true italic
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "rose-pine-moon" },
  },
}
