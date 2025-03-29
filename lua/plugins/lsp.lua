return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmet_language_server = {
          filetypes = { "html", "htmldjango" },
        },
        cssls = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
      },
      formatters = {
        ruff_fix = {
          -- sort imports: ruff check --fix --select I
          append_args = { "--select", "I" },
        },
      },
    },
  },
}
