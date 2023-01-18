{ lib, config, pkgs, ... }:

lib.mkProfile "gui" {
  imports = [
    ./theme
  ];

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    xcursor-pixelfun
  ];

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      ia-writer-duospace
      unifont
      siji
      fira-code
      fira-code-symbols
      fira-mono
      font-awesome
      iosevka-comfy.comfy
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Iosevka Comfy" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  services.greetd = {
    enable = true;
    settings.default_session.command =
      let
        theme = config._.theme.gtkTheme;
        sway-greeter-config =
          let
            xkb_variant = builtins.replaceStrings [ " " ] [ "" ] config.services.xserver.xkbVariant;
            xkb_options = builtins.replaceStrings [ " " ] [ "" ] config.services.xserver.xkbOptions;
          in
          pkgs.writeText "sway-greeter.config" ''
            input "type:keyboard" {
              xkb_layout ${config.services.xserver.layout}
              ${lib.optionalString (xkb_variant != "") "xkb_layout ${xkb_variant}"}
              ${lib.optionalString (xkb_options != "") "xkb_options ${xkb_options}"}
            }

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
      in
      "${pkgs.sway}/bin/sway --config ${sway-greeter-config}";
  };
  environment.etc."greetd/environments".text = ''
    Hyprland
    sway
  '';

  programs.sway = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  nixpkgs.overlays = [
    (self: super: {
      slack = super.slack.overrideAttrs (old: {
        installPhase = old.installPhase + ''
          rm $out/bin/slack

          makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
          --add-flags "--enable-features=WebRTCPipeWireCapturer %U"
        '';
      });
    })
  ];

  services.accounts-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  services.gnome.glib-networking.enable = true;
  services.gnome.at-spi2-core.enable = true;
  services.gvfs.enable = true;

  i18n.inputMethod = {
    enabled = "ibus";
  };
}
