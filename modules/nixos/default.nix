{ pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in {
  imports = [
    ./gui
    ./command-line.nix
    ./default-user.nix
    ./home-manager.nix
    ./locale.nix
    ./networkmanager.nix
    ./sshd.nix
  ];

  _module.args = {
    secrets = import ../../secrets;
  };

  nix.package = mkDefault pkgs.nixUnstable;
  nix.extraOptions = mkDefault ''
    experimental-features = nix-command flakes
  '';

  _.home-manager.forAllUsers.home.stateVersion = mkDefault "20.09";
}
