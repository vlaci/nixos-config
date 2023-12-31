{ config, lib, ... }:

let
  cfg = config._.theme;
  inherit (lib) mkOption;
in
{
  imports = [ ./theme.nix ];

  options._.theme = {
    cursorTheme.name = mkOption { };
    cursorTheme.package = mkOption { };

    gtkTheme.dark.name = mkOption { };
    gtkTheme.dark.package = mkOption { };
    gtkTheme.light.name = mkOption { };
    gtkTheme.light.package = mkOption { };

    kvantumTheme.name = mkOption { };
    kvantumTheme.package = mkOption { };

    iconTheme.name = mkOption { };
    iconTheme.package = mkOption { };
  };
}
