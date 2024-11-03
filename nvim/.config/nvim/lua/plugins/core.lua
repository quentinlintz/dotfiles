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
          cmd = { os.getenv("HOME") .. "/.asdf/shims/solargraph", "stdio" }, -- Install solargraph
          root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
        },
        rubocop = {
          mason = false,
          cmd = { "bundle", "exec", "rubocop", "--lsp" }, -- Project's rubocop
          root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
        },
        verible = {
          cmd = { "verible-verilog-ls", "--rules_config_search" },
          filetypes = { "verilog", "systemverilog", "verilog_systemverilog" },
        },
        asm_lsp = {
          filestypes = { "asm", "s", "S" },
        },
        clangd = {
          cmd = { os.getenv("HOME") .. "/.espressif/tools/esp-clang/16.0.1-fe4f10a809/esp-clang/bin/clangd" }, -- ESP32 clangd
          root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git", "."),
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        asm = { "asmfmt" },
      },
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
  {
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
  },
}
