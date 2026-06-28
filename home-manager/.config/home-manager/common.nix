{ pkgs, ... }: {
  home.packages = with pkgs; [
    # home-manager
    nodejs_22
    stow
    git-lfs
    diff-so-fancy
    direnv
    nix-direnv
    ripgrep
    entr
    fd
    ffmpeg
    fzf
    neovim
    git-filter-repo
    go
    lua
    hugo
    google-cloud-sdk
    # nmap
    tmux
    tmuxinator
    nil
  ];

  home.file = {};

  home.sessionVariables = {};

  programs.home-manager.enable = true;
}
