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
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- add formatters, linters, or LSPs to ensure installed via Mason here
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        htmldjango = { "djangofmt" },
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
