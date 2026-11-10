return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        emmet_language_server = {
          filetypes = { "html", "htmldjango" },
        },
        cssls = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "mbake",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        htmldjango = { "djangofmt" },
        make = { "bake" },
      },
      formatters = {
        ruff_fix = {
          -- sort imports: ruff check --fix --select I
          append_args = { "--select", "I" },
        },
        djangofmt = {
          command = "djangofmt",
          args = { "--indent-width", 2, "-" },
          stdin = true,
        },
      },
    },
  },
}
