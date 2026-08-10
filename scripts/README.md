# scripts

Stow package for `~/.local/bin/`. Small rclone-backed utilities for browsing
and acting on remote files without saving them to local disk.

```
scripts/.local/bin/
├── rcplay    # select media on a remote, then hand off to rcreview
├── rcfind    # select remote files, print their paths for piping elsewhere
├── rctypes   # list extensions present on a remote, print the selected ones
├── rcreview  # play/rename/delete/skip files piped in on stdin
├── rcdelete  # bulk-delete files piped in on stdin, no per-file review
├── rcmove    # move files piped in on stdin to a chosen/given directory
└── rccopy    # copy files piped in on stdin to a chosen/given directory
```

Both require `rclone`, `fzf`, `mpv`/`curl`/`python3` on PATH, and an rclone
remote already configured (`rclone listremotes`). Viewing `.stl` files also
needs MeshLab (`brew install --cask meshlab`) — checked on demand, not at
startup, since it's only needed if an STL turns up in the review.

## rcplay

```
rcplay <remote:path>
```

1. Lists every file under `<remote:path>` and multiselects (fzf) which
   **extensions** to include — video, audio, image, and STL types (`mp4`,
   `mkv`, `mov`, `avi`, `webm`, `m4v`, `mp3`, `flac`, `wav`, `ogg`, `m4a`,
   `jpg`, `jpeg`, `png`, `gif`, `webp`, `bmp`, `tiff`, `heic`, `stl`). Leaving
   the fzf query empty shows all of them.
2. Lists matching files and multiselects which ones to review.
3. Pipes the selected full `remote:path` list into `rcreview` (see below) for
   playback and review.

## rcreview

```
rcfind <remote:path> | rcreview
rcplay <remote:path>   # uses this internally
```

Takes full `remote:path` lines on stdin — no selection UI of its own, so it
composes with `rcfind`, `rcplay`, or any other producer of remote paths.

1. For video/audio/image files, starts a local `rclone serve http` for the
   remote and streams the file into `mpv` — nothing is written to disk.
   Images stay open until closed (`--image-display-duration=inf`), same as
   video/audio.
2. For `.stl` files (MeshLab can't stream): downloads to a temp file,
   opens it in MeshLab, waits for you to close it, then deletes the temp
   file immediately. If the STL is over 100 MB, it asks
   `download to view? [y/N]` first, since that's a real local download.
3. After each file, prompts:
   - `r` — rename (enter the new name without an extension; spaces become
     `-`; the original extension is kept)
   - `d` — delete on the remote, with immediate size feedback
   - `q` — quit the whole review, skipping any remaining files
   - Enter — continue to the next file
4. On exit (including via `q`), prints a summary: files deleted and total
   space freed.

Since stdin is used for the incoming file list, mpv and the rename/delete
prompts read from `/dev/tty` directly so keyboard control still works.

## rcfind

```
rcfind [filter] <remote:path>
```

General-purpose file picker, no playback, no rename/delete:

1. Lists every file under `<remote:path>`. With no `filter`, that's
   everything. With a `filter` (e.g. `stl`), the listing itself is narrowed
   first via rclone's `--include "*stl*"` — only matching files are ever
   fetched or shown.
2. Opens fzf over that (already-filtered) list so you can narrow further.
3. Prints the full `remote:path` of each selected file to stdout, one per
   line — safe to pipe into another command:
   ```
   rcfind gdrive_hey:Videos | xargs -I{} rclone copy {} gdrive-mwc:Archive/
   rcfind stl gdrive_hey:Models | xargs -I{} rclone copy {} gdrive-mwc:Printable/
   ```

## rctypes

```
rctypes <remote:path>
```

Lists every file extension actually present under `<remote:path>` (not a
hardcoded list) and multiselects via fzf. Prints the selected extensions to
stdout, one per line — useful for scoping down before an `rcfind`/`rcplay`
pass, or piping into your own filtering.

## rcdelete

```
rcfind <remote:path> | rcdelete [-f|--force]
```

Bulk delete with no per-file review — for when you already know you want
everything selected gone. Composes with `rcfind` or any other producer of
`remote:path` lines, same as `rcreview`.

1. Looks up each input file's size and sums the total.
2. Prompts once: `About to delete N file(s), totaling X — proceed? [y/N]`
   — skip this with `-f`/`--force` (mirrors `rm -f`).
3. Deletes each, printing `Deleted: path (size)`; failures are reported but
   don't stop the rest.
4. Prints a final summary: files deleted and total space freed.

## rcmove / rccopy

```
rcfind <remote:path> | rcmove [-l] [--to remote:directory]
rcfind <remote:path> | rccopy [-l] [--to remote:directory]
```

Identical behavior — `rcmove` uses `rclone moveto`, `rccopy` uses `rclone
copyto`. Composes with `rcfind` or any other producer of `remote:path`
lines.

- **No flag, or `-l`** (explicit alias for the default): lists every
  directory on the *same remote* as the piped-in files (`rclone lsf
  --dirs-only -R`) and opens a single-select fzf (`.` represents the
  remote's root) to pick exactly one destination. Picking it completes the
  move/copy — there's no separate confirmation prompt beyond the fzf
  selection itself.
- **`--to remote:directory`** (or `--to=remote:directory`): skips the
  picker and goes straight there — the only way to move/copy **across
  remotes**, since the interactive picker only browses the source's own
  remote.

Each file lands at `<destination>/<original-basename>`, with per-file
feedback and a final success/fail summary:
```
rcfind gdrive_hey:Videos | rcmove --to gdrive-mwc:Archive
rcfind stl gdrive_hey:Models | rccopy
```

## fzf conventions

All three tools share the same fzf multiselect bindings:

- `tab` — toggle the current item and move the cursor **up** (reversed from
  fzf's default of moving down)
- `ctrl-a` — select all

## Gotchas

- Stow links files individually, not the whole `.local/bin/` directory —
  after adding a new script here, re-run `stow scripts` from the repo root
  or it won't show up on PATH.
