{ pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  nix.extraOptions = mkDefault ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
  '';
  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;

  system.activationScripts.diff = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    echo
    echo =================================  [ Changes ]  =================================
    ${pkgs.nvd}/bin/nvd diff /run/current-system "$systemConfig"
    echo =================================================================================
    echo
  '';
}
