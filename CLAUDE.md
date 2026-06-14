# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## How this repo works

Managed with **GNU Stow**. Each top-level directory is a stow package — its contents mirror `$HOME`. Running `stow <package>` creates symlinks from `~` into the package directory.

**Never edit files in `~/.config` or `~` directly** — always edit in `~/.dotfiles` and let the symlinks propagate.

```bash
# Apply a package for the first time
cd ~/.dotfiles && stow tmux

# Apply all packages at once
cd ~/.dotfiles && stow */

# Reload tmux config without restarting
tmux source-file ~/.dotfiles/tmux/.config/tmux/tmux.conf
# or inside tmux: prefix + r
```

## Package map

| Directory | Symlink target |
|-----------|---------------|
| `aliases/` | `~/.aliases` |
| `zsh/` | `~/.zshrc` |
| `nvim/` | `~/.config/nvim/` |
| `tmux/` | `~/.config/tmux/` |
| `tmuxinator/` | `~/.config/tmuxinator/` and `~/tmuxinator_completion.zsh` |
| `elixir/` | `~/.iex.exs` |
| `tealdeer/` | `~/Library/Application Support/tealdeer/` |

## Neovim config

The nvim package lives at `nvim/.config/nvim/` and has its own `CLAUDE.md` — read that for plugin/keymap details. Summary:

- Entry point: `init.lua` (kickstart.nvim base)
- Custom plugins: `lua/custom/plugins/`
- Lua formatter: `stylua` (2-space indent, 160-col, single quotes — see `.stylua.toml`)
- Format buffer: `<leader>f`

## Shell

`zsh/.zshrc` sources `~/.aliases` (which lives at `aliases/.aliases`). Aliases include short git wrappers (`gs`, `ga`, `gd`, `gl`, etc.), fzf-powered file pickers (`op`, `fif`, `Files`), and Elixir helpers (`mixtest` with fswatch, `mixtesthead`).

## Tmux

Config at `tmux/.config/tmux/tmux.conf`. Gruvbox-dark statusline, vi copy-mode, mouse on. Key bindings of note:

- `prefix + |` / `prefix + -` — vertical/horizontal split (preserves cwd)
- `prefix + r` — reload config
- `prefix + ^` — new session
- `M-Right` — select pane right (no prefix)
