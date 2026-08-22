-- Go overrides.
--
-- Most of LazyVim's lang.go extra is now correct for these projects, because the
-- projects moved to meet it rather than the other way round. What is left is
-- the three things LazyVim cannot know.
return {
  -- Format by piping the buffer through the project's own linter rather than
  -- through standalone goimports and gofumpt binaries.
  --
  -- LazyVim's default pair produces the same bytes *today*, but only because
  -- both sides happen to be configured the same way. The moment .golangci.yml
  -- gains a setting the editor does not mirror (local-prefixes is exactly such
  -- a setting), a save starts writing something `make fmt` rewrites, and
  -- `make check` fails on a file that was just saved.
  --
  -- One binary reading one config removes the class of bug instead of the
  -- instance. Verified: `--stdin` output is byte-identical to what
  -- `golangci-lint fmt <file>` writes, idempotent, and on a syntax error it
  -- echoes the input back rather than emptying the buffer. Costs ~20ms a save.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.golangci_fmt = {
        command = "golangci-lint",
        args = { "fmt", "--stdin" },
        stdin = true,
        -- --stdin has no filename to resolve config from, so run it where the
        -- config actually is rather than wherever nvim happens to be.
        cwd = require("conform.util").root_file({
          ".golangci.yml",
          ".golangci.yaml",
          ".golangci.toml",
          ".golangci.json",
          "go.work",
          "go.mod",
        }),
      }

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.go = { "golangci_fmt" }
    end,
  },

  -- Version parity with CI. LazyVim's extra asks mason to install these, but
  -- mise already provides them, pinned to the versions .github/workflows/ci.yml
  -- uses. Two copies means mason's unpinned one wins on PATH and the editor
  -- starts disagreeing with `make lint` after some unrelated mason update.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local mise_owns = { "gopls", "golangci-lint", "delve", "gofumpt", "goimports" }
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return not vim.tbl_contains(mise_owns, tool)
      end, opts.ensure_installed or {})
    end,
  },

  -- A ledger tested without the race detector proves nothing. `make test` uses
  -- -race, so the editor's test runner has to as well, or a green run in the
  -- sidebar means less than a green run in the terminal.
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["neotest-golang"] = {
          go_test_args = { "-v", "-race", "-count=1" },
          dap_go_enabled = true,
        },
      },
    },
  },
}
