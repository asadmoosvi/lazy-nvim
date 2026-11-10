# 💤 LazyVim

My [LazyVim](https://github.com/LazyVim/LazyVim) config.

Refer to [LazyVim's documentation](https://lazyvim.github.io/installation) to customize it to your liking.

## Installation

[Install neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) then clone this repository to your user's config directory.

```bash
git clone https://github.com/asadmoosvi/lazy-nvim ~/.config/nvim
```

## Code Runner

Includes a simple code runner for executing programs written in various programming languages.

### Keybinds

| Keybind      | Description                    |
| ------------ | ------------------------------ |
| `<leader>rr` | Run current file               |
| `<leader>re` | Enable code runner for session |
| `<leader>rd` | Disable code runner            |

### Adding Custom Runners

To add support for another language, edit the `runners` table in `lua/config/code_runner.lua`:

```lua
javascript = { cmd = "node %file%", requires = "node" },
```

* `cmd`: The shell command to execute. Use `%file%` for the full file path and `%output%` for the path without extension (for compiled languages).
* `requires`: The name of the executable to check for before running (e.g. `node`, `clang`, `python3`).
