{ lib, config, pkgs, ... }:

lib.mkProfile "gui" {
  imports = [
    ./hyprland.nix
    ./niri.nix
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

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    catppuccin.enable = true;
    package = pkgs.kdePackages.sddm;
  };

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
