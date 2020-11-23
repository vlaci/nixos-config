{ pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in {
  imports = [
    ./gui
    #./default-user.nix
    ./home-manager.nix
    ./locale.nix
    ./networkmanager.nix
    ./services.nix
    ./users.nix
    ./zsh.nix
  ];

  nix.package = mkDefault pkgs.nixUnstable;
  nix.extraOptions = mkDefault ''
    experimental-features = nix-command flakes
  '';

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
