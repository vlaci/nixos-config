{ pkgs, ... }:

{
  _.theme = {
    colors = {
      foreground = "#CDD6F4";
      background = "#1E1E2E";

      # black
      color0 = "#45475A";
      color8 = "#585B70";

      # red
      color1 = "#F38BA8";
      color9 = "#F38BA8";

      # green
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";

      # yellow
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";

      # blue
      color4 = "#89B4FA";
      color12 = "#89B4FA";

      # magenta
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";

      # cyan
      color6 = "#94E2D5";
      color14 = "#94E2D5";

      # white
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
    };

    wallpaper = ./wallpaper.jpeg;

    cursorTheme.name = "pixelfun3";
    cursorTheme.package = pkgs.xcursor-pixelfun;

    gtkTheme.name = "Nordic-darker";
    gtkTheme.package = pkgs.nordic;

    iconTheme.name = "Papirus";
    iconTheme.package = pkgs.papirus-icon-theme;

    name = "Nord";
  };
}
