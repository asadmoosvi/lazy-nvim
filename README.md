# 💤 LazyVim

My [LazyVim](https://github.com/LazyVim/LazyVim) config.

Refer to [LazyVim's documentation](https://lazyvim.github.io/installation) to customize it to your liking.

## Installation

[Install neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) then clone this repository to your user's config directory.

```bash
git clone https://github.com/asadmoosvi/lazy-nvim ~/.config/nvim
```

## Code Runner

Includes a custom code runner for quick execution of single-file programs. Ships with support for C, C++, Rust, Python, Bash, Lua, and Go out of the box, with smart detection of build systems (Makefile for C/C++, Cargo for Rust). Additional languages can be added easily. Must be enabled each session to prevent accidental execution.

### Keybinds

| Keybind      | Description                    |
| ------------ | ------------------------------ |
| `<leader>rr` | Run current file               |
| `<leader>re` | Enable code runner for session |
| `<leader>rd` | Disable code runner            |

### Adding Custom Runners

To add support for another language, edit the `runners` table in `lua/config/code_runner.lua`:

```lua
javascript = "node %file%",
```

Use `%file%` for the full file path and `%output%` for the path without extension (for compiled languages).
