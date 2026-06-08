-- code_runner.lua
-- Provides <leader>r keymap to run code for supported filetypes

local M = {}

-- Runner commands per filetype
local runners = {
  c = "if [ -f Makefile ]; then make run; else clang %file% -o %output% && %output%; fi",
  cpp = "if [ -f Makefile ]; then make run; else clang++ %file% -o %output% && %output%; fi",
  python = "python3 %file%",
  sh = "bash %file%",
  lua = "lua %file%",
  go = "go run %file%",
  rust = 'if [ "$(cargo locate-project 2>/dev/null)" ]; then cargo run -q; else rustc %file% -o %output% && %output%; fi',
}

-- Session state
local runner_enabled = false
local term_buf = nil

-- Close the previous runner terminal if it exists
local function close_runner_terminal()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    -- Close any window showing this buffer first
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == term_buf then
        vim.api.nvim_win_close(win, true)
      end
    end
    vim.api.nvim_buf_delete(term_buf, { force = true })
  end
  term_buf = nil
end

-- Run the code for the current buffer's filetype
local function run_code()
  if not runner_enabled then
    vim.notify("Code runner disabled. Enable with <leader>re or :CodeRunnerEnable", vim.log.levels.WARN)
    return
  end

  local ft = vim.bo.filetype
  local cmd = runners[ft]
  if not cmd then
    vim.notify("No runner configured for filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  -- Save view state before any window changes
  local view = vim.fn.winsaveview()
  local src_win = vim.api.nvim_get_current_win()

  close_runner_terminal()

  -- Save the file
  vim.cmd("silent write")

  -- Build the shell command
  local file = vim.fn.shellescape(vim.fn.expand("%:p"))
  cmd = cmd:gsub("%%file%%", file)
  if cmd:find("%%output%%") then
    cmd = cmd:gsub("%%output%%", vim.fn.shellescape(vim.fn.expand("%:p:r")))
  end

  -- Open terminal in a split
  if vim.o.columns > 120 then
    vim.cmd("vertical terminal " .. cmd)
  else
    vim.cmd("15split | terminal " .. cmd)
  end

  -- Track the new terminal buffer and give it a clean name
  term_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(term_buf, "[Runner] " .. vim.fn.expand("#:t"))

  -- Return focus to the source window and restore cursor
  vim.api.nvim_set_current_win(src_win)
  vim.fn.winrestview(view)
end

function M.setup()
  -- Session gate commands
  vim.api.nvim_create_user_command("CodeRunnerEnable", function()
    runner_enabled = true
    vim.notify("Code runner enabled for this session", vim.log.levels.INFO)
  end, { desc = "Enable code runner for this session" })

  vim.api.nvim_create_user_command("CodeRunnerDisable", function()
    runner_enabled = false
    vim.notify("Code runner disabled", vim.log.levels.INFO)
  end, { desc = "Disable code runner" })


  vim.api.nvim_create_user_command("CodeRunnerStatus", function()
    vim.notify("Code runner is " .. (runner_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
  end, { desc = "Show code runner status" })

  -- Register which-key group label
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add({ { "<leader>r", group = "Code Runner" } })
  end

  -- Keymaps under <leader>r group
  vim.keymap.set("n", "<leader>rr", run_code, { desc = "Run Code" })
  vim.keymap.set("n", "<leader>re", "<cmd>CodeRunnerEnable<cr>", { desc = "Enable Code Runner" })
  vim.keymap.set("n", "<leader>rd", "<cmd>CodeRunnerDisable<cr>", { desc = "Disable Code Runner" })

  -- Stop insert mode when the runner terminal exits
  vim.api.nvim_create_autocmd("TermClose", {
    callback = function(args)
      if args.buf == term_buf then
        vim.cmd("stopinsert")
      end
    end,
  })
end

return M
