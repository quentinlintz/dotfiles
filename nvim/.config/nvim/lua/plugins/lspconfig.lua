local lspconfig = require("lspconfig")

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      solargraph = {
        mason = false,
        cmd = { os.getenv("HOME") .. "/.asdf/shims/solargraph", "stdio" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
      },
      rubocop = {
        mason = false,
        cmd = { "bundle", "exec", "rubocop", "--lsp" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
      },
      verible = {
        cmd = { "verible-verilog-ls", "--rules_config_search" },
        filetypes = { "verilog", "systemverilog", "verilog_systemverilog" },
      },
      asm_lsp = {
        mason = false,
        filestypes = { "asm", "s", "S" },
      },
      clangd = {
        -- ESP config
        -- cmd = {
        --   os.getenv("HOME") .. "/.espressif/tools/esp-clang/17.0.1_20240419/bin/clangd",
        --   "--all-scopes-completion",
        --   "--background-index",
        --   "--clang-tidy",
        -- },
        -- Default config
        cmd = {
          os.getenv("HOME") .. "/.local/share/nvim/mason/bin/clangd",
          "--background-index", -- Indexes files in the background
          "--completion-style=bundled", -- Provides completion suggestions
          "--header-insertion=iwyu", -- Suggests headers following include-what-you-use
        },
        root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git", "."),
      },
    },
  },
}
