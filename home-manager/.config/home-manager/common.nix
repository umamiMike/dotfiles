{ pkgs, ... }: {
  home.packages = with pkgs; [
    # home-manager
    nodejs_24
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
	tree-sitter
    git-filter-repo
    go
    lua
    hugo
    google-cloud-sdk
    cabal-install
    (haskellPackages.ghcWithPackages (p: with p; [ text containers ]))
	cht-sh
    # nmap
    tmux
    tmuxinator
    nil
  ];

  home.file = {};

  home.sessionVariables = {};

  # programs.home-manager.enable = true;
}
