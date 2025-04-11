return {
  {
    -- highlighting for chezmoi files template files
    "alker0/chezmoi.vim",
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
    end,
  },
  {
    "xvzc/chezmoi.nvim",
    init = function()
      -- run chezmoi edit on file enter
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
        callback = function()
          local filepath = vim.fn.expand("%:p")
          -- dont apply scripts
          if not filepath:match("/.chezmoiscripts/") then
            vim.schedule(require("chezmoi.commands.__edit").watch)
          end
        end,
      })
    end,
  },
}
