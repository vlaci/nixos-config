{ pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  imports = [
    ./cachix
    ./gui
    ./yubikey
    ./development.nix
    ./email.nix
    ./home-manager.nix
    ./locale.nix
    ./networkmanager.nix
    ./nix.nix
    ./secrets.nix
    ./services.nix
    ./security.nix
    ./users.nix
    ./work.nix
    ./zsh.nix
  ];

  _.home-manager.forAllUsers.home.stateVersion = mkDefault "20.09";

  environment.systemPackages = with pkgs; [
    bind
    cifs-utils
    exfat
    exfat-utils
    git
    ntfs3g
    xdg-user-dirs
  ];
}
