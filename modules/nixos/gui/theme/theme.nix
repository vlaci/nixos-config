{ pkgs, ... }:

{
  stylix = {
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
    gtkTheme.dark.name = "Catppuccin-Mocha-Standard-Lavender-Dark";
    gtkTheme.dark.package = pkgs.catppuccin-gtk.override {
      accents = [ "lavender" ];
      variant = "mocha";
    };

    gtkTheme.light.name = "Catppuccin-Latte-Standard-Lavender-Light";
    gtkTheme.light.package = pkgs.catppuccin-gtk.override {
      accents = [ "lavender" ];
      variant = "latte";
    };

    kvantumTheme.name = "Catppuccin-Mocha-Lavender";
    kvantumTheme.package = pkgs.catppuccin-kvantum.override {
      accent = "Lavender";
      variant = "Mocha";
    };

    iconTheme.name = "Papirus-Light";
    iconTheme.package = pkgs.papirus-icon-theme;

  };
}
