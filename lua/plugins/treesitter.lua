return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      indent = {
        disable = { "go" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    keys = {
      {
        "<M-l>",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
        end,
        mode = "n",
        desc = "Swap Next Parameter",
      },
      {
        "<M-h>",
        function()
          require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
        end,
        mode = "n",
        desc = "Swap Previous Parameter",
      },
    },
  },
}
