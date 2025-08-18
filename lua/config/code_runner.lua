-- code_runner.lua
-- Provides <leader>r keymap to run code for supported filetypes

local M = {}

-- Session state for code runner activation
local runner_enabled = false

-- Generic function to set up a code runner keymap
local function setup_code_runner(opts)
  vim.keymap.set("n", "<leader>r", function()
    -- Check if code runner is enabled
    if not runner_enabled then
      vim.notify("Code runner disabled. Run :CodeRunnerEnable first", vim.log.levels.WARN)
      return
    end

    -- save the current view state FIRST, before any cleanup
    local view = vim.fn.winsaveview()

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

    -- return focus to the previous window and restore view state
    vim.cmd("wincmd p")
    vim.fn.winrestview(view)
  end, { desc = opts.desc, buffer = true })
end

-- Configuration for supported filetypes
local runners = {
  c = {
    runner_id = "c_runner",
    command = "[ -f Makefile ] && make run || { gcc %file% -o %output% && %output%; }",
    desc = "Run C File",
  },
  cpp = {
    runner_id = "cpp_runner",
    command = "[ -f Makefile ] && make run || { g++ %file% -o %output% && %output%; }",
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
  go = {
    runner_id = "go_runner",
    command = "go run %file%",
    desc = "Run Go File",
  },
  rust = {
    runner_id = "rust_runner",
    command = '[ "$(cargo locate-project 2>/dev/null)" ] && cargo run -q || { rustc %file% -o %output% && %output%; }',
    desc = "Run Rust File",
  },
}

-- Set up autocmds for supported filetypes
function M.setup()
  -- Create user commands for code runner control
  vim.api.nvim_create_user_command("CodeRunnerEnable", function()
    runner_enabled = true
    vim.notify("Code runner enabled for this session", vim.log.levels.INFO)
  end, { desc = "Enable code runner for this session" })

  vim.api.nvim_create_user_command("CodeRunnerDisable", function()
    runner_enabled = false
    vim.notify("Code runner disabled", vim.log.levels.INFO)
  end, { desc = "Disable code runner" })

  vim.api.nvim_create_user_command("CodeRunnerStatus", function()
    local status = runner_enabled and "enabled" or "disabled"
    vim.notify("Code runner is " .. status, vim.log.levels.INFO)
  end, { desc = "Show code runner status" })

  vim.api.nvim_create_user_command("CodeRunnerToggle", function()
    runner_enabled = not runner_enabled
    local status = runner_enabled and "enabled" or "disabled"
    vim.notify("Code runner " .. status, vim.log.levels.INFO)
  end, { desc = "Toggle code runner" })

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
