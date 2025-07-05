return {
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
}
