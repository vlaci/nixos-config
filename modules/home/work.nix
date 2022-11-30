{ lib, pkgs, nixosConfig, ... }:

let
  inherit (lib) mkIf;
  inherit (nixosConfig._.secrets) vlaci;
in
lib.mkProfile "work" {
  home.packages = with pkgs; [
    teams
    slack
    openfortivpn
  ];
}
