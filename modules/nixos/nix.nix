{ pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  nix.package = mkDefault pkgs.nixUnstable;
  nix.extraOptions = mkDefault ''
    experimental-features = nix-command flakes
    plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
    extra-builtins-file = ${../../lib/_extra-builtins.nix}
  '';
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nix = pkgs.nixUnstable;
    };
  };
}
