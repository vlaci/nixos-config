{ pkgs, ... }:

{
  stylix = {
    enable = true;

    image = ./wallpaper.jpeg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.berkeley-mono-typeface;
        name = "Berkeley Mono";
      };

      sizes = {
        desktop = 12;
        popups = 12;
      };
    };

    cursor = {
      package = pkgs.xcursor-pixelfun;
      name = "pixelfun3";
    };
  };

  _.theme = {
    iconTheme.name = "Papirus-Light";
    iconTheme.package = pkgs.papirus-icon-theme;
  };
}
