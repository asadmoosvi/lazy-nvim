return {
  -- highlighting for chezmoi files template files
  "alker0/chezmoi.vim",
  init = function()
    vim.g["chezmoi#use_tmp_buffer"] = 1
  end,
}
