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
  programs.git = mkIf vlaci.available {
    userEmail = vlaci.value.email.work.address;
  };
}
