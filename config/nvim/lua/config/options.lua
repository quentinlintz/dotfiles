-- Loaded by LazyVim before its own options. See lazyvim.org/configuration/general.
--
-- Deliberately tiny. Indentation is not set here: Neovim reads .editorconfig
-- natively, and every repo worth opening has one, so LazyVim's defaults plus
-- that file already land on tabs for Go and two spaces for YAML.

local opt = vim.opt

-- Trust-gated per-directory config. This is what loads ledger/.nvim.lua and its
-- <leader>m Makefile bindings. Nvim prompts once per file, then remembers.
opt.exrc = true

-- Claude Code rewrites files from the tmux pane next door. LazyVim already
-- checks on FocusGained; lua/config/autocmds.lua widens that to pane switches.
opt.autoread = true

-- Rounded floats everywhere, including LSP hover.
opt.winborder = "rounded"
