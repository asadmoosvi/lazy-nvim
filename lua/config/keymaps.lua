-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")

-- Run programs
wk.add({
  { "<leader>r", group = "Run" },
})

-- Run python file
local python_runner_bufnr = nil
vim.keymap.set("n", "<leader>rp", function()
  if vim.bo.filetype ~= "python" then
    vim.notify("Not a python file", vim.log.levels.WARN)
    return
  end
  -- Save the file
  vim.cmd("w")

  -- Close previous python runner terminal buffer if it exists
  if python_runner_bufnr and vim.api.nvim_buf_is_valid(python_runner_bufnr) then
    vim.cmd("bd! " .. python_runner_bufnr)
  end

  -- Choose split direction based on editor width
  local split_cmd = vim.o.columns < 100 and "split" or "vsplit"
  local runner_cmd = vim.fn.executable("uv") == 1 and "uv run" or "python3"
  local term_cmd = string.format("%s | terminal %s %%", split_cmd, runner_cmd)
  vim.cmd(term_cmd)
  python_runner_bufnr = vim.api.nvim_get_current_buf()
  -- Go back to previous window
  vim.cmd("wincmd p")
end, { desc = "Run python file" })
