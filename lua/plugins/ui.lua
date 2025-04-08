return {
  -- colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
  -- indent guide
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        indent = {
          char = "▏",
        },
        scope = {
          char = "▏",
          enabled = false,
        },
      },
    },
  },
}
