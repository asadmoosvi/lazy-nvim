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
        hyprls = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "djlint" })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        htmldjango = { "djlint" },
      },
      formatters = {
        ruff_fix = {
          -- sort imports: ruff check --fix --select I
          append_args = { "--select", "I" },
        },
        djlint = {
          append_args = { "--indent", 2 },
        },
      },
    },
  },
}
