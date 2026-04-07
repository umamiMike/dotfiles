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
