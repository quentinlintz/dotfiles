return {
  {
    "akinsho/git-conflict.nvim",
    version = "*", -- Pin to the latest stable version
    config = function()
      require("git-conflict").setup({
        default_mappings = true, -- Enable default mappings (co, ct, cb, c0, etc.)
        disable_diagnostics = false, -- Keep diagnostics enabled (optional)
        highlights = { -- Customize highlights (optional)
          incoming = "DiffAdd",
          current = "DiffChange",
        },
      })
    end,
  },
}
