# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## How this repo works

Managed with **GNU Stow**. Each top-level directory is a stow package — its contents mirror `$HOME`. Running `stow <package>` creates symlinks from `~` into the package directory.

**Never edit files in `~/.config` or `~` directly** — always edit in `~/.dotfiles` and let the symlinks propagate.

```bash
# Apply a single package
cd ~/.dotfiles && stow tmux

# Apply all packages at once
cd ~/.dotfiles && stow */

# Unlink a package
stow -D nvim

# Preview without applying
stow -n nvim

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

Entry point: `nvim/.config/nvim/init.lua` (kickstart.nvim base). Custom plugins in `nvim/.config/nvim/lua/custom/plugins/`:
- `init.lua` — fugitive, gruvbox, typescript-tools, code_runner
- `mini.lua` — mini.nvim (ai, surround, statusline)
- `codecomp.lua` — CodeCompanion.nvim wired to Claude via the external CLI adapter

Custom commands in `nvim/.config/nvim/lua/custom/commands.lua`:
- `:CopyPythonComments` — extract inline comments from selection to clipboard
- `:FindMarkdown` — Telescope picker for `.md` files
- `:FindBreakpoints` — find Python `breakpoint()` calls

Lua formatter: `stylua` (2-space indent, 160-col, single quotes — see `.stylua.toml`). Format buffer: `<leader>f`.

## Shell

`zsh/.zshrc` sources `~/.aliases` (at `aliases/.aliases`). Aliases include short git wrappers (`gs`, `ga`, `gd`, `gl`, etc.), fzf-powered file pickers (`op`, `fif`, `Files`), and Elixir helpers (`mixtest` with fswatch, `mixtesthead`). NVM is lazy-loaded; pyenv is initialized inline.

## Tmux

Config at `tmux/.config/tmux/tmux.conf`. Gruvbox-dark statusline, vi copy-mode, mouse on. Key bindings of note:

- `prefix + |` / `prefix + -` — vertical/horizontal split (preserves cwd)
- `prefix + r` — reload config
- `prefix + ^` — new session
- `M-Right` — select pane right (no prefix)

`keymaps.md` has the full tmux and Neovim keybinding reference — check it before adding new bindings to avoid conflicts.

## Tmuxinator

Templates at `tmuxinator/.config/tmuxinator/`, grouped by project (`delboy/`, `refuge/`) plus a few top-level ones. Follow existing `.yml` patterns when adding new session templates.
