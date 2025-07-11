return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    auto_install = true,
    textobjects = {
      swap = {
        enable = true,
        swap_next = {
          ["<M-l>"] = "@parameter.inner",
        },
        swap_previous = {
          ["<M-h>"] = "@parameter.inner",
        },
      },
    },
  },
}
