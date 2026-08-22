-- Claude Code runs in the tmux pane next door, not inside Neovim.
--
-- `provider = "none"` is the whole point. claudecode.nvim still starts its
-- WebSocket server and writes the ~/.claude/ide/<port>.lock file the CLI reads,
-- so selections, diffs and file context all work. It just never opens a window
-- of its own. Start the neighbouring pane with `claude --ide`, or run /ide in a
-- session that is already going.
--
-- <leader>a is free: LazyVim only claims it in the ai.* extras, none of which
-- are enabled in lazyvim.json.
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    -- Not lazy. The plugin's whole job here is to have a WebSocket server
    -- listening and a ~/.claude/ide/<port>.lock file on disk BEFORE `claude
    -- --ide` starts in the next pane, because that is the file claude reads to
    -- find the editor. Loading on first <leader>as is too late: by then claude
    -- has already looked, found nothing, and given up.
    lazy = false,
    priority = 100,
    opts = {
      terminal = { provider = "none" },
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to context" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)

      -- Sending a selection should leave you looking at where the reply will
      -- appear. focus_after_send cannot do this when the terminal isn't ours,
      -- so hop the tmux pane instead. {last} is the previously active pane,
      -- which in the workbench layout is claude.
      vim.api.nvim_create_autocmd("User", {
        pattern = "ClaudeCodeSendComplete",
        callback = function()
          if vim.env.TMUX then
            vim.system({ "tmux", "select-pane", "-t", "{last}" })
          end
        end,
      })
    end,
  },
}
