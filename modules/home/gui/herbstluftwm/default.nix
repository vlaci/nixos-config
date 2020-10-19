{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in {
  home.file = {
    ".config/herbstluftwm".source = mkDefault ./config;
  };

  home.packages = with pkgs; [
    polybar
    kitty
  ];
}
