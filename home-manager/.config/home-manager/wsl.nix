{ pkgs, ... }: {
  home.username = "mikew";
  home.homeDirectory = "/home/mikew";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # colima
    # devenv
    # gcc-unwrapped
    # git-lfs
    # google-cloud-sdk
    # nil
    # syncthing
    # tealdeer
    # tmux
   # tmuxinator
  ];
}
