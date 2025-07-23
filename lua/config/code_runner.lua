-- code_runner.lua
-- Provides <leader>r keymap to run code for supported filetypes

local M = {}

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

-- Configuration for supported filetypes
local runners = {
  cpp = {
    runner_id = "cpp_runner",
    command = "g++ %file% -o %output% && %output%",
    desc = "Run C++ File",
  },
  python = {
    runner_id = "python_runner",
    command = "python %file%",
    desc = "Run Python File",
  },
  sh = {
    runner_id = "bash_runner",
    command = "bash %file%",
    desc = "Run Bash File",
  },
  lua = {
    runner_id = "lua_runner",
    command = "lua %file%",
    desc = "Run Lua File",
  },
}

-- Set up autocmds for supported filetypes
function M.setup()
  -- Stop insert mode on terminal close
  vim.api.nvim_create_autocmd("TermClose", {
    pattern = "*",
    callback = function()
      vim.cmd("stopinsert")
    end,
  })

  -- Set up runners for all configured filetypes
  local filetypes = {}
  for ft, _ in pairs(runners) do
    table.insert(filetypes, ft)
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(event)
      setup_code_runner(runners[event.match])
    end,
  })
end

return M
