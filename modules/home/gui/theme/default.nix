{ config, lib, pkgs, nixosConfig, ... }:

let
  theme = nixosConfig._.theme;
  inherit (lib) concatStrings mapAttrsToList mkOption;
in
{
  config = {
    gtk = { enable = true; inherit (theme) iconTheme; theme = theme.gtkTheme; };
    home.pointerCursor = (theme.cursorTheme // { x11 = { enable = true; }; });
    programs.kitty.settings = theme.colors // {
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";

      # Cursor colors
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";

      # URL underline color when hovering with mouse
      url_color = "#F5E0DC";

      # Kitty window border colors
      active_border_color = "#B4BEFE";
      inactive_border_color = "#6C7086";
      bell_border_color = "#F9E2AF";

      # OS Window titlebar colors
      wayland_titlebar_color = "system";
      macos_titlebar_color = "system";

      # Tab bar colors
      active_tab_foreground = "#11111B";
      active_tab_background = "#CBA6F7";
      inactive_tab_foreground = "#CDD6F4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111B";

      # Colors for marks (marked text in the terminal)
      mark1_foreground = "#1E1E2E";
      mark1_background = "#B4BEFE";
      mark2_foreground = "#1E1E2E";
      mark2_background = "#CBA6F7";
      mark3_foreground = "#1E1E2E";
      mark3_background = "#74C7EC";

    };
    programs.rofi.theme = ./rofi.rasi;
    xdg.dataFile."rofi/themes/colors.rasi".text = ''
      * {
        al:  #00000000;
        tx:  ${theme.colors.color4};
        bg:  ${theme.colors.background};
        se:  ${theme.colors.color6};
        fg:  ${theme.colors.foreground};
        ac:  ${theme.colors.color8};
      }
    '';

    programs.bat = {
      config.theme = "_theme";
      themes = {
        _theme = builtins.readFile "${pkgs.pkgsrcs.catpuccin-bat.src}/Catppuccin-mocha.tmTheme";
      };

    };
    xdg.configFile."colors.sh".text = concatStrings (mapAttrsToList (n: v: "export ${n}='${v}'\n") theme.colors);
    xresources.properties = (theme.colors // {
      wallpaper = toString theme.wallpaper;
    });
  };
}
