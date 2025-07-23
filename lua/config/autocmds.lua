-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- css comments fix
vim.api.nvim_create_autocmd("FileType", {
  pattern = "css",
  command = "setlocal formatoptions-=cro",
})

-- stop insert mode on terminal close
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function()
    vim.cmd("stopinsert")
  end,
})

-- Generic function to set up a code runner keymap
local function setup_code_runner(opts)
  vim.keymap.set("n", "<leader>r", function()
    -- find and close the previous terminal buffer
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == "terminal" and vim.b[buf][opts.runner_id] then
        vim.api.nvim_buf_delete(buf, { force = true })
        break
      end
    end

    -- prepare the command
    vim.cmd("w") -- Save the current file
    local file = vim.fn.expand("%:p")
    local output_file = vim.fn.expand("%:p:r")
    local cmd = opts.command
    cmd = cmd:gsub("%%file%%", vim.fn.fnameescape(file))
    cmd = cmd:gsub("%%output%%", vim.fn.fnameescape(output_file))

    -- open the terminal in a split
    if vim.o.columns > 120 then
      vim.cmd("vertical terminal " .. cmd)
    else
      vim.cmd("15split | terminal " .. cmd)
    end

    -- mark the new terminal buffer
    local term_buf = vim.api.nvim_get_current_buf()
    vim.b[term_buf][opts.runner_id] = true

    -- return focus to the previous window
    vim.cmd("wincmd p")
  end, { desc = opts.desc, buffer = true })
end

-- run cpp files using <leader>r
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    setup_code_runner({
      runner_id = "cpp_runner",
      command = "g++ %file% -o %output% && %output%",
      desc = "Run C++ File",
    })
  end,
})

-- run python files using <leader>r
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    setup_code_runner({
      runner_id = "python_runner",
      command = "python %file%",
      desc = "Run Python File",
    })
  end,
})