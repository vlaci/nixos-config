{ config, lib, ... }:

let
  cfg = config._.theme;
  inherit (lib) mkOption;
in
{
  imports = [ ./theme.nix ];

  options._.theme = {
    colors = {
      background = mkOption {
        default = cfg.color0;
      };
      foreground = mkOption {
        default = cfg.color15;
      };
      color0 = mkOption {
        default = "#282828";
      };
      color1 = mkOption {
        default = "#cc241d";
      };
      color2 = mkOption {
        default = "#98971a";
      };
      color3 = mkOption {
        default = "#d79921";
      };
      color4 = mkOption {
        default = "#458588";
      };
      color5 = mkOption {
        default = "#b16286";
      };
      color6 = mkOption {
        default = "#689d6a";
      };
      color7 = mkOption {
        default = "#189984";
      };
      color8 = mkOption {
        default = "#928374";
      };
      color9 = mkOption {
        default = "#fb4934";
      };
      color10 = mkOption {
        default = "#b8bb26";
      };
      color11 = mkOption {
        default = "#fabd2f";
      };
      color12 = mkOption {
        default = "#83a598";
      };
      color13 = mkOption {
        default = "#d3869b";
      };
      color14 = mkOption {
        default = "#8ec07c";
      };
      color15 = mkOption {
        default = "#ebdbb2";
      };
    };

    wallpaper = mkOption {
      default = ./wallpaper.jpeg;
    };

    cursorTheme.name = mkOption { };
    cursorTheme.package = mkOption { };

    gtkTheme.name = mkOption { };
    gtkTheme.package = mkOption { };

    iconTheme.name = mkOption { };
    iconTheme.package = mkOption { };

    name = mkOption { };
  };

  config.services.xserver.displayManager.lightdm = {
    background = config._.theme.wallpaper;
    greeters.enso = {
      inherit (config._.theme) cursorTheme iconTheme; theme = config._.theme.gtkTheme;
    };
  };
}
