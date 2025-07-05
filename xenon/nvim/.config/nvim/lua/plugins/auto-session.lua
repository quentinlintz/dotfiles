return {
  "rmagatti/auto-session",
  init = function()
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
  lazy = false,
  keys = {
    { "<leader>wr", "<cmd>SessionSearch<CR>", desc = "Session search" },
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
    { "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
    { "<leader>wd", "<cmd>SessionDelete<CR>", desc = "Delete session" },
  },
  opts = {
    cwd_change_handling = true,
    pre_cwd_changed_cmds = { "Neotree close" },
    post_cwd_changed_cmds = { "Neotree left" },
    allowed_dirs = { "~/.dotfiles/*", "~/workspace/*" },
  },
}
