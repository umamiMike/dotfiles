---
{}
---
**dotfiles repo is the source of truth**


- never edit files in `~/.config` directly 
- edit in `~/.dotfiles` and the symlinks take care of the rest.

The only two things to remember are: **edit in `~/.dotfiles`**, and **run stow when you add something new**.
---

## Day to day

```bash
# Edit a config — work directly in dotfiles
nvim ~/.dotfiles/tmux/.config/tmux/tmux.conf

# Save your changes
cd ~/.dotfiles
git add .
git commit -m "tmux: add window naming prompt"
git push
```

---

## On a new machine

make sure you install stow

```bash
git clone git@github.com:you/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow bash
stow tmuxinator
stow nvim

# all

stow */
```

---

## Pulling changes from another machine

When you `git pull`, symlinks for **existing files** update automatically — they already point into `~/.dotfiles/`, so git updating the file is enough.

You need to re-run stow when a pull introduces **new files or directories** that don't have symlinks yet:

```bash
# Safe to run any time — only adds missing symlinks, leaves existing ones alone
git pull && stow */
```

Making `stow */` a habit after pulling ensures everything stays linked, especially on a machine you haven't used in a while.

---

## If you add a new tool (e.g. zsh)

Stow's home folder is ~/dotfiles/
Everything inside a stow package is a mirror image of your home directory. When you run stow tmuxinator, stow walks into ~/dotfiles/tmuxinator/ and says "pretend this folder is ~" — then creates symlinks for everything it finds, preserving the path structure.

```bash

# create a directory structure  
mkdir -p ~/.dotfiles/tmuxinator/.config/tmuxinator
# move the files from the config
mv ~/.config/tmuxinator/*.yml ~/dotfiles/tmuxinator/.config/tmuxinator/
# stow the tool
cd .dotfiles
stow tmuxinator


... commit the dotfiles
```
