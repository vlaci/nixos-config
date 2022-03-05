{ lib, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config._.gui.wayland;

  sway-greeter-config = pkgs.writeText "sway-greeter.config" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; ${pkgs.sway}/bin/swaymsg exit"

    bindsym Mod4+shift+e exec swaynag \
	    -t warning \
	    -m 'What do you want to do?' \
	    -b 'Poweroff' 'systemctl poweroff' \
	    -b 'Reboot' 'systemctl reboot'

    #include /etc/sway/config.d/*
  '';
in {
  options = {
    _.gui.wayland.enable = mkEnableOption "wayland";
  };
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.sway}/bin/sway --config ${sway-greeter-config}";
    };
    programs.sway.extraPackages = with pkgs; [ swayidle swaylock ];
    programs.sway.enable = true;
  };
}
