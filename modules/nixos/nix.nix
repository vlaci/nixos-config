{ pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  nix.package = mkDefault pkgs.nixUnstable;
  nix.extraOptions = mkDefault ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nix = pkgs.nixUnstable;
      nix-prefetch-git = pkgs.nix-prefetch-git.override { nix = pkgs.nixUnstable; };
    };
  };

  environment.systemPackages = with pkgs; [
    nix-index
  ];
}
