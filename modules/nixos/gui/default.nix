{ lib, config, pkgs, ... }:

lib.mkProfile "gui" {
  imports = [
    ./hyprland.nix
    ./theme
  ];

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
  };

  _.users.forAllUsers.persist.directories = [
    ".local/state/wireplumber"
  ];

  environment.systemPackages = with pkgs; [
    pavucontrol
    xcursor-pixelfun
    xdg-utils
  ];

  fonts = {
    packages = with pkgs; [
      berkeley-mono-typeface
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
        monospace = [ "Berkeley Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  location.provider = "geoclue2";
  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyDwr302FpOSkGRpLlUpPThNTDPbXcIn_FM";
  };

  services.greetd = {
    enable = true;
    settings.default_session.command =
      let
        theme = config._.theme.gtkTheme.dark;
        sway-greeter-config =
          let
            inherit (config.services.xserver) xkb;
            xkb_variant = builtins.replaceStrings [ " " ] [ "" ] xkb.variant;
            xkb_options = builtins.replaceStrings [ " " ] [ "" ] xkb.options;
          in
          pkgs.writeText "sway-greeter.config" ''
            input "type:keyboard" {
              xkb_layout ${xkb.layout}
              ${lib.optionalString (xkb_variant != "") "xkb_variant ${xkb_variant}"}
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
    wlr.enable = lib.mkForce true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  nixpkgs.overlays = [
    (self: super: {
      slack = super.slack.overrideAttrs (old: {
        postFixup = ''
          # https://github.com/flathub/com.slack.Slack/commit/4d655060447be5c1e09ea3ad822fa786a6e3d9a3
          sed -i 's/WebRTCPipeWireCapturer/LebRTCPipeWireCapturer/g' $out/lib/slack/resources/app.asar
        '';
      });
    })
  ];

  services.accounts-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
}
