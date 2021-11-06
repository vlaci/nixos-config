{ lib, pkgs, nixosConfig, ... }:

lib.mkProfile "work" {
  home.packages = with pkgs; [
    teams
    openfortivpn
  ];
  programs.git.userEmail = nixosConfig._.secrets.vlaci.email.work.address;
}
