{ pkgs, lib, ... }:

{
  imports = [
    ./cachix
    ./gui
    ./yubikey
    ./development.nix
    ./email.nix
    ./home-manager.nix
    ./keyboardio.nix
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

  environment.systemPackages = with pkgs; [
    bind
    cifs-utils
    exfat
    exfat
    git
    ntfs3g
    xdg-user-dirs
  ];
}
