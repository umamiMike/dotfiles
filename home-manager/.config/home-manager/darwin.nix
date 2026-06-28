{ pkgs, ... }: {
  home.username = "mikew";
  home.homeDirectory = "/Users/mikew";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # arp-scan
    # asciinema
    # cabal-install
    # rustup
    # caddy
    iproute2mac
    yj
  ];
}
