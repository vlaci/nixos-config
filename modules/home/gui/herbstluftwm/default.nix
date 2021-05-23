{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkProfile;
in
mkProfile "herbstluftwm" {
  home.file = {
    ".config/herbstluftwm".source = mkDefault ./config;
  };

  home.packages = with pkgs; [
    polybar
  ];

  xsession = {
    enable = true;
    scriptPath = ".xsession-hm";
    windowManager.command = "herbstluftwm";
  };
}
