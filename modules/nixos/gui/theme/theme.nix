{ pkgs, ... }:

{
  _.theme = {
    colors = {
      foreground = "#D8DEE9";
      background = "#2E3440";

      # black
      color0 = "#3B4252";
      color8 = "#4C566A";

      # red
      color1 = "#BF616A";
      color9 = "#BF616A";

      # green
      color2 = "#A3BE8C";
      color10 = "#A3BE8C";

      # yellow
      color3 = "#EBCB8B";
      color11 = "#EBCB8B";

      # blue
      color4 = "#81A1C1";
      color12 = "#81A1C1";

      # magenta
      color5 = "#B48EAD";
      color13 = "#B48EAD";

      # cyan
      color6 = "#88C0D0";
      color14 = "#8FBCBB";

      # white
      color7 = "#E5E9F0";
      color15 = "#ECEFF4";
    };

    wallpaper = ./wallpaper.jpeg;

    cursorTheme.name = "pixelfun3";
    cursorTheme.package = pkgs.xcursor-pixelfun;

    gtkTheme.name = "Nordic";
    gtkTheme.package = pkgs.nordic;

    iconTheme.name = "Zafiro-icons";
    iconTheme.package = pkgs.zafiro-icons;

    name = "Nord";
  };
}
