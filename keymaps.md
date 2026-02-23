# Keymaps Reference

> **tmux prefix**: `Ctrl-b` (default)
> **nvim leader**: `Space`

---

## tmux

### Sessions & Windows

| Key | Action |
|-----|--------|
| `prefix + c` | New window (preserving path) |
| `prefix + ^` | New session |
| `prefix + m` | Move current window to a new session |
| `prefix + @` | Choose window → join as horizontal pane |
| `prefix + C-@` | Choose window → join as vertical pane |

### Panes

| Key | Action |
|-----|--------|
| `prefix + \|` | Split left (horizontal) |
| `prefix + -` | Split above (vertical) |
| `prefix + X` | Respawn pane (no prompt) |
| `prefix + Q` | Kill pane |
| `M-Right` | Select pane to the right |

### Misc

| Key | Action |
|-----|--------|
| `prefix + r` | Reload tmux config |
| `prefix + h` | Toggle status bar |

### Copy Mode (vi)

| Key | Action |
|-----|--------|
| `Enter` | Copy selection → clipboard (pbcopy on macOS) |

---

## Neovim

### Navigation & Windows

| Key | Mode | Action |
|-----|------|--------|
| `-` | n | Open netrw (go up directory) |
| `Space \` | n | Vertical split |
| `Space -` | n | Horizontal split |
| `C-S-h` | n | Move window left |
| `C-S-l` | n | Move window right |
| `C-S-j` | n | Move window down |
| `C-S-k` | n | Move window up |
| `C-l` | n | quickfix next (`cnext`) |
| `C-k` | n | quickfix prev (`cprev`) |
| `<Esc>` | n | Clear search highlight |
| `<Esc><Esc>` | t | Exit terminal mode |

### Telescope / Search (`Space s`)

| Key | Action |
|-----|--------|
| `Space sh` | Search help tags |
| `Space sk` | Search keymaps |
| `Space sf` | Find files |
| `Space ss` | Select telescope picker |
| `Space sw` | Grep word under cursor |
| `Space sg` | Live grep |
| `Space sd` | Search diagnostics |
| `Space sr` | Resume last search |
| `Space s.` | Recent files |
| `Space s/` | Live grep in open files |
| `Space sn` | Search nvim config files |
| `Space /` | Fuzzy search current buffer |
| `Space Space` | Find open buffers |

### LSP (active when LSP attached)

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Go to definition |
| `gv` | n | Go to definition (vertical split) |
| `grr` | n | Go to references |
| `gri` | n | Go to implementation |
| `grD` | n | Go to declaration |
| `gra` | n/x | Code action |
| `gO` | n | Document symbols |
| `gw` | n | Workspace symbols |
| `lt` | n | Type definition |
| `Space lr` | n | Rename symbol |
| `Space f` | n/v | Format buffer (conform) |
| `Space q` | n | Open diagnostic quickfix list |
| `Space th` | n | Toggle inlay hints |

### Git — Fugitive (`Space g`)

| Key | Action |
|-----|--------|
| `Space go` | Open git status in tab |
| `Space gc` | Git commit |
| `Space gca` | Git commit --amend |
| `Space ga` | Git add current file |

### Git — Gitsigns (`Space h`)

| Key | Mode | Action |
|-----|------|--------|
| `]c` | n | Next git change |
| `[c` | n | Previous git change |
| `Space hs` | n/v | Stage hunk |
| `Space hr` | n/v | Reset hunk |
| `Space hS` | n | Stage buffer |
| `Space hu` | n | Undo stage hunk |
| `Space hR` | n | Reset buffer |
| `Space hp` | n | Preview hunk |
| `Space hb` | n | Blame line |
| `Space hd` | n | Diff against index |
| `Space hD` | n | Diff against last commit |
| `Space tb` | n | Toggle inline blame |
| `Space tD` | n | Toggle show deleted (inline) |

### Run / Build (`Space r`)

| Key | Action |
|-----|--------|
| `Space ru` / `F5` | Run file (code_runner) |
| `S-F5` | Run neotest |
| `Space rv` | g++ build + run in tmux vertical split |
| `Space rx` | g++ build with -g + run gdb in tmux split |
| `Space rh` | g++ build + run in horizontal terminal |

### Python Helpers

| Key | Mode | Action |
|-----|------|--------|
| `Space p` | n | Insert `print("word: ", word)` for word under cursor |
| `Space p` | v | Insert `print("sel: ", sel)` for selection |
| `Space x` | n | Add `cout <<` for current line |

### Misc

| Key | Mode | Action |
|-----|------|--------|
| `Space [` | n | Convert line to checklist item (`- [ ]`) |
| `td` | n | Toggle todo.md split |
| `Space tt` | n | Open todo.md in vertical split |
| `Space te` | n | Open python examples directory |
| `Space ew` | v | Extract selection to new file |
| `Space cc` | n | Open Claude Code in tmux split |
| `nn` | v | Narrow region (NrrwRgn) |

### Completion — blink.cmp (preset: `enter`)

| Key | Action |
|-----|--------|
| `Enter` | Confirm completion |
| `Tab` / `S-Tab` | Next / previous item |
| `C-space` | Trigger completion |

### Surround — mini.surround

| Key | Action |
|-----|--------|
| `sa{motion}` | Add surrounding |
| `sd{char}` | Delete surrounding |
| `sr{old}{new}` | Replace surrounding |
| `sf` / `sF` | Find surrounding (right / left) |
| `sh` | Highlight surrounding |

### Text Objects — mini.ai (extended)

Works with `a`/`i` + these objects:

| Object | Description |
|--------|-------------|
| `f` | Function call |
| `a` | Argument / parameter |
| `t` | HTML/XML tag |
| `(` `)` `[` `]` `{` `}` | Brackets |
| `"` `'` `` ` `` | Quotes |
