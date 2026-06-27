{ pkgs, ... }: {
  home.username = "mike";
  home.homeDirectory = "/home/mike";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    tmux
    neovim
    ripgrep
    fd
    fzf
    tmuxinator
    entr
    hugo
    marksman
    tealdeer
    stow
    ffmpeg
    git-lfs
    nodejs_22
    go
    gcc-unwrapped
    google-cloud-sdk
    syncthing
    devenv
    nil
    colima
  ];
}
