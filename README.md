# 💤 LazyVim

My [LazyVim](https://github.com/LazyVim/LazyVim) config.

Refer to [LazyVim's documentation](https://lazyvim.github.io/installation) to customize it to your liking.

## Installation

[Install neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) then clone this repository to your user's config directory.

```bash
git clone https://github.com/asadmoosvi/lazy-nvim ~/.config/nvim
```

## Code Runner

A basic code runner is included for running programs directly from Neovim.

Press `<leader>r` to compile and run code files. The runner automatically saves your file, opens a terminal split (vertical for wide screens, horizontal for narrow), and executes the appropriate command based on file type.

:information_source: Note: the `<leader>` key is set to space by default in LazyVim.

Supports C, C++, Python, Bash, and Lua out of the box.

To add support for additional languages, edit `lua/config/code_runner.lua` and add entries to the `runners` table. Each entry requires:

- **Key**: The filetype name (what Neovim detects for the file)
- **runner_id**: A unique identifier for this runner's terminal buffer (allows the runner to close previous output from the same language)
- **command**: The shell command to execute (use `%file%` for full file path, `%output%` for filename without extension)
- **desc**: Description shown in keybinding help

Examples:

```lua
local runners = {
  javascript = {
    runner_id = "js_runner",
    command = "node %file%",
    desc = "Run JavaScript File",
  },
  -- For compiled languages that need both compilation and execution:
  go = {
    runner_id = "go_runner",
    command = "go build -o %output% %file% && %output%",
    desc = "Run Go File",
  },
}
```
