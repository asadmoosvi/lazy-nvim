return {
  -- colorscheme
  {
    "folke/tokyonight.nvim",
    opts = {
      -- See https://github.com/folke/tokyonight.nvim/issues/703#issuecomment-2765214186
      on_highlights = function(hl, c)
        hl.TabLineFill = {
          bg = c.none,
        }
      end,
    },
  },
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
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      local bufferline = require("bufferline")
      opts.options.style_preset = bufferline.style_preset.minimal
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false
    end,
  },
}
