-- Plugins LazyVim ships that something else here already does.
--
-- These live in LazyVim's own specs, so `enabled = false` is the only way to
-- express the removal. What actually takes them off disk and out of
-- lazy-lock.json is `:Lazy clean`.
--
-- nui.nvim has to be listed by name. It looks like a noice dependency but
-- LazyVim declares it as a standalone spec (plugins/ui.lua), so disabling noice
-- leaves it installed and `:Lazy clean` will not collect it. The only other
-- thing that wants it is the avante extra, which is not enabled.
return {
  -- The buffer list is the tmux window list. A second one across the top of the
  -- editor is the same information twice, in a place you don't look.
  { "akinsho/bufferline.nvim", enabled = false },

  -- Replaces the cmdline and the message area wholesale. When it breaks, the
  -- symptom is an editor that has stopped telling you things, which is a worse
  -- failure than the ugly cmdline it was hiding.
  { "folke/noice.nvim", enabled = false },
  { "MunifTanjim/nui.nvim", enabled = false },

  -- Opens a browser to render markdown. `glow` does it in a tmux popup without
  -- leaving the terminal, and C-b ? already relies on that.
  { "iamcco/markdown-preview.nvim", enabled = false },

  -- LazyVim's default colorschemes, unused since rose-pine is set in
  -- colorscheme.lua. Carrying two more is just lockfile churn.
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", enabled = false },
}
