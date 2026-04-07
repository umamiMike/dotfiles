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
stow -d ~/.dotfiles -t ~ nvim
stow -d ~/.dotfiles -t ~ tmux
# etc
```

---

## If you add a new tool (e.g. zsh)

```bash
mkdir -p ~/.dotfiles/zsh
mv ~/.zshrc ~/.dotfiles/zsh/.zshrc
cd ~/.dotfiles
stow -d ~/.dotfiles -t ~ zsh
git add .
git commit -m "add zsh config"
git push
```

---

