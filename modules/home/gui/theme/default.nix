{ config, lib, pkgs, nixosConfig, ... }:

let
  theme = nixosConfig._.theme;
  inherit (lib) concatStrings mapAttrsToList mkOption;
in
{
  config = {
    gtk = { enable = true; inherit (theme) iconTheme; theme = lib.mkForce theme.gtkTheme.dark; };
    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "kvantum";
    };

    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      theme=${theme.kvantumTheme.name}
    '';

    xdg.configFile."Kvantum/${theme.kvantumTheme.name}" = {
      source = "${theme.kvantumTheme.package}/share/Kvantum/${theme.kvantumTheme.name}";
    };

    home.packages = [
      theme.gtkTheme.dark.package
      theme.gtkTheme.light.package
    ];
    stylix.opacity.terminal = 0.85;

    stylix.targets.kitty.variant256Colors = true;

    services.darkman = {
      darkModeScripts.color-scheme-dark = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'${nixosConfig._.theme.gtkTheme.dark.name}'"
        echo dark > $XDG_RUNTIME_DIR/color-scheme
      '';

      lightModeScripts.color-scheme-light = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'${nixosConfig._.theme.gtkTheme.light.name}'"
        echo light > $XDG_RUNTIME_DIR/color-scheme
      '';
    };
    systemd.user.services.darkman.Service.Environment = "PATH=${lib.makeBinPath [ pkgs.bash ]}";
  };
}
