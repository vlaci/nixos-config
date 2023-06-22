{ pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  nix.package = mkDefault pkgs.nixUnstable;
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

  environment.systemPackages = with pkgs; [
    nix-index
  ];
}
