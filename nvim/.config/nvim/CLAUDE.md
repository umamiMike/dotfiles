# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a customized fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — a single-file starter configuration that has been extended with custom plugins and keymaps. The primary entry point is `init.lua`; modular additions live under `lua/`.

## Plugin Manager

**lazy.nvim** — auto-bootstrapped from `init.lua`. The lock file (`lazy-lock.json`) is tracked in git.

## Architecture

```
init.lua                        # Main config (~723 lines) — options, keymaps, core plugins
lua/
  kickstart/plugins/            # Opt-in kickstart modules (autopairs, gitsigns, debug, etc.)
  custom/
    commands.lua                # User-defined :commands
    plugins/
      init.lua                  # Custom plugin list (fugitive, gruvbox, typescript-tools, etc.)
      mini.lua                  # mini.nvim (ai, surround, statusline)
      codecomp.lua              # CodeCompanion.nvim (bridges to Claude Code CLI)
.stylua.toml                    # Lua formatter: 2-space indent, 160-col width, single quotes
```

### Plugin loading tiers

1. **Core plugins** — defined inline in `init.lua` (LSP stack, telescope, treesitter, colorscheme, etc.)
2. **Kickstart optional plugins** — loaded via `require 'kickstart.plugins.<name>'` at the bottom of `init.lua`; several are commented out (debug, indent_line, lint, neo-tree)
3. **Custom plugins** — loaded via `{ import = 'custom.plugins' }` which auto-imports all files under `lua/custom/plugins/`

### LSP stack

- **mason.nvim** handles LSP/tool installation
- Configured servers: `pyright`, `ruff`, `lua_ls`, `marksman`, `typescript-tools`
- **blink.cmp** provides completions
- **conform.nvim** handles formatting on save (`stylua` for Lua, `ruff_fix`/`ruff_format` for Python, `clang-format` for C++)

## Lua Formatting

Use `stylua` (configured via `.stylua.toml`). It is installed via mason. To format the current buffer: `<leader>f`.

## Key Keymaps Reference

Leader key is `<Space>`.

| Keymap | Action |
|--------|--------|
| `<leader>sf` | Telescope find files |
| `<leader>sg` | Live grep |
| `td` | Open `todo.md` in vsplit |
| `<leader>lr` | LSP rename |
| `<leader>f` | Format buffer |
| `<leader>go` | Open fugitive in tab |
| `<leader>ru` / `<F5>` | Run file (code_runner) |
| `<leader>o` | Open Claude Code in tmux split |
| `-` | Netrw file explorer |

## Notable Customizations

- `scrolloff = 40` — keeps the cursor well-centered vertically
- Folding by indent, open by default
- `<leader>rv` / `<leader>rx` / `<leader>rh` — build C++ with g++ and run in tmux/split variants
- `<leader>p` — insert a Python `print()` statement from word or visual selection
- `:FindMarkdown`, `:FindBreakpoints`, `:CopyPythonComments` — custom commands in `lua/custom/commands.lua`
- CodeCompanion configured with `external_command` adapter pointing to the Claude CLI
