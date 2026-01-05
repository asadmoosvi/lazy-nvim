# 💤 LazyVim

My [LazyVim](https://github.com/LazyVim/LazyVim) config.

Refer to [LazyVim's documentation](https://lazyvim.github.io/installation) to customize it to your liking.

## Installation

[Install neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) then clone this repository to your user's config directory.

```bash
git clone https://github.com/asadmoosvi/lazy-nvim ~/.config/nvim
```

## Code Runner

Includes a custom code runner for quick execution of single-file programs. Press `<leader>r` to run the current file in a terminal split, automatically compiling first for compiled languages (C, C++, Rust). Supports Python, Bash, Lua, and Go as well, with smart detection of build systems (Makefile for C/C++, Cargo for Rust). Must be enabled each session with `:CodeRunnerEnable` to prevent accidental execution.

### Adding Custom Runners

To add support for another language, edit the `runners` table in `lua/config/code_runner.lua`:

```lua
javascript = {
  runner_id = "js_runner",
  command = "node %file%",
  desc = "Run JavaScript File",
},
```

Use `%file%` for the full file path and `%output%` for the path without extension.
