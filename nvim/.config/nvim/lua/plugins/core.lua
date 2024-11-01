local lspconfig = require("lspconfig")

return {
  "LazyVim/LazyVim",
  opts = {
    colorscheme = "catppuccin",
  },
  {
    "akinsho/toggleterm.nvim",
    config = true,
    cmd = "ToggleTerm",
    keys = { { "<F4>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" } },
    opts = {
      open_mapping = [[<F4>]],
      direction = "float",
      shade_filetypes = {},
      hide_numbers = true,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      close_on_exit = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Create a .solargraph.yml with `max_files: 0` in project root
        solargraph = {
          mason = false,
          cmd = { os.getenv("HOME") .. "/.asdf/shims/solargraph", "stdio" }, -- Run `gem install solargraph`
          root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
        },
        rubocop = {
          mason = false,
          cmd = { "bundle", "exec", "rubocop", "--lsp" }, -- Project's rubocop
          root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        rubocop = {
          command = "bundle",
          args = {
            "exec",
            "rubocop",
            "--server",
            "--autocorrect-all",
            "--format",
            "quiet",
            "--stderr",
            "--stdin",
            "$FILENAME",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    opts = function(_, opts)
      opts.endwise = { enable = true }
    end,
  },
}
