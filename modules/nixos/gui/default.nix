{ lib, config, pkgs, ... }:

lib.mkProfile "gui" {
  imports = [
    ./lightdm-cursor-fix.nix
    ./theme
    ./wayland.nix
  ];
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
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
      (iosevka-bin.override { variant = "ss05"; })
      (iosevka-bin.override { variant = "aile"; })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Iosevka" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # programs.dconf.profiles.gdm = lib.mkForce (
  # let
  #   customDconf = pkgs.writeTextFile {
  #     name = "gdm-dconf";
  #     destination = "/dconf/gdm-custom";
  #     text = ''
  #       [org/gnome/desktop/interface]
  #       cursor-theme='pixelfun3'
  #     '';
  #   };

  #   customDconfDb = pkgs.stdenv.mkDerivation {
  #     name = "gdm-dconf-db";
  #     buildCommand = ''
  #       ${pkgs.dconf}/bin/dconf compile $out ${customDconf}/dconf
  #     '';
  #   };
  #   inherit (pkgs.gnome3) gdm;
  # in pkgs.stdenv.mkDerivation {
  #   name = "dconf-gdm-cursor-profile";
  #   buildCommand = ''
  #     # Check that the GDM profile starts with what we expect.
  #     if [ $(head -n 1 ${gdm}/share/dconf/profile/gdm) != "user-db:user" ]; then
  #       echo "GDM dconf profile changed, please update gdm.nix"
  #       exit 1
  #     fi
  #     # Insert our custom DB behind it.
  #     sed '2ifile-db:${customDconfDb}' ${gdm}/share/dconf/profile/gdm > $out
  #   '';
  # });

  location.provider = "geoclue2";
  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
    };

    # https://github.com/NixOS/nixpkgs/issues/75007
    # https://github.com/NixOS/nixpkgs/pull/73785
    # https://github.com/thiagokokada/dotfiles/commit/17057a544dcb8a51e3b9b1ea92c476edd6e2cc46
    inputClassSections = [
      ''
        Identifier "mouse"
        Driver "libinput"
        MatchIsPointer "on"
        Option "AccelProfile" "flat"
      ''
      ''
        Identifier "touchpad"
        Driver "libinput"
        MatchIsTouchpad "on"
        Option "NaturalScrolling" "true"
      ''
    ];

    desktopManager.xterm.enable = false;
    desktopManager.session = [{
      name = "home-manager";
      start = ''
        ${pkgs.stdenv.shell} $HOME/.xsession-hm &
        waitPID=$!
      '';
    }
    {
      name = "dummy";
      start = "true";
    }
    ];

    displayManager.lightdm =
      {
        enable = !config._.gui.wayland.enable;
        greeters.enso = {
          enable = true;
          blur = !(lib.hasAttr "vm" config.system.build);
        };
      };
  };

  services.accounts-daemon.enable = true;
  services.autorandr.enable = !config._.gui.wayland.enable;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  services.gnome.glib-networking.enable = true;
  services.gnome.at-spi2-core.enable = true;
  services.gvfs.enable = true;

  i18n.inputMethod = {
    enabled = "ibus";
  };
}
