{ config, lib, pkgs, nixosConfig, ... }:

let
  theme = nixosConfig._.theme;
  inherit (lib) concatStrings mapAttrsToList mkOption;
in
{
  config = {
    gtk = { enable = true; inherit (theme) iconTheme; };
    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita";
    };

    stylix.opacity.terminal = 0.85;

    stylix.targets.kde.enable = false;
    stylix.targets.kitty.variant256Colors = true;

    services.darkman = {
      darkModeScripts.color-scheme-dark = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        echo dark > $XDG_RUNTIME_DIR/color-scheme
      '';

      lightModeScripts.color-scheme-light = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        echo light > $XDG_RUNTIME_DIR/color-scheme
      '';
    };
    systemd.user.services.darkman.Service.Environment = "PATH=${lib.makeBinPath [ pkgs.bash ]}";
  };
}
