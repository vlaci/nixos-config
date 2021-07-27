{ config, lib, pkgs, nixosConfig, ... }:

let
  theme = nixosConfig._.theme;
  inherit (lib) concatStrings mapAttrsToList mkOption;
in
{
  config = {
    gtk = { inherit (theme) iconTheme; theme = theme.gtkTheme; };
    programs.kitty.settings = theme.colors;
    programs.rofi.theme = ./nord.rasi;
    programs.bat.config.theme = theme.name;
    xdg.configFile."colors.sh".text = concatStrings (mapAttrsToList (n: v: "export ${n}='${v}'\n") theme.colors);
    xresources.properties = (theme.colors // {
      wallpaper = toString theme.wallpaper;
    });
  };
}
