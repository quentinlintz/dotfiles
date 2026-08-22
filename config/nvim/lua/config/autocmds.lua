-- Loaded by LazyVim in addition to its own autocmds, not instead of them.

-- LazyVim already runs :checktime on FocusGained, TermClose and TermLeave, and
-- with 'focus-events on' in tmux that covers switching panes too, since tmux sends
-- FocusIn to the pane it moves to.
--
-- What it does not cover is sitting still. Claude Code rewrites a file in the
-- pane next door while you are reading the buffer it just replaced, and nothing
-- fires until you move. CursorHold is the one that closes that gap; BufEnter is
-- cheap insurance for buffers opened while a rewrite was in flight.
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("checktime_extra", { clear = true }),
  callback = function()
    if vim.o.buftype == "" and vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Say so when a buffer was replaced underneath you, rather than swapping the
-- text out silently.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = vim.api.nvim_create_augroup("changed_notice", { clear = true }),
  callback = function()
    vim.notify("Buffer reloaded: changed on disk", vim.log.levels.WARN)
  end,
})
