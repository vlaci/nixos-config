{ lib, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config._.gui.wayland;

  sway-greeter-config = pkgs.writeText "sway-greeter.config" ''
    exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "GTK_DATA_PREFIX=${theme.package} GTK_THEME=${theme.name} ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; ${pkgs.sway}/bin/swaymsg exit"

    bindsym Mod4+shift+e exec swaynag \
	    -t warning \
	    -m 'What do you want to do?' \
	    -b 'Poweroff' 'systemctl poweroff' \
	    -b 'Reboot' 'systemctl reboot'

    #include /etc/sway/config.d/*
  '';
  theme = config._.theme.gtkTheme;
in {
  options = {
    _.gui.wayland.enable = mkEnableOption "wayland";
  };
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.sway}/bin/sway --config ${sway-greeter-config}";
    };
    environment.etc."greetd/environments".text = ''
      sway
    '';

    programs.sway = {
      enable = true;
    };

    services.pipewire = {
      enable = true;
    };

    xdg.portal = {
      enable = true;
      gtkUsePortal = true;
      wlr.enable = true;
    };
  };
}
