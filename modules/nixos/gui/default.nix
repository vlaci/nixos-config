
{ lib, pkgs, ... }:

lib.mkProfile "gui" {
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };

    #environment.systemPackages = with pkgs; [
    #  gvfs  # automounting and mtp
    #];

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
        # emacs-all-the-icons-fonts
        iosevka
      ];
      fontconfig = {
        # localConf = builtins.readFile ./fonts.conf;
        defaultFonts = {
          monospace = [ "Fira Mono" ];
          sansSerif = [ "Noto Sans" ];
          serif = [ "Noto Serif" ];
        };
      };
    };

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
     # desktopManager.session = [{
     #   name = "home-manager";
     #   start = ''
     #   ${pkgs.stdenv.shell} $HOME/.xsession-hm &
     #   waitPID=$!
     #   '';
     # }];

      displayManager.lightdm =
      {
        enable = mkDefault true;
        greeters.enso = {
          enable = mkDefault true;
          blur = !(hasAttr "vm" config.system.build);
          cursorTheme = {
            package = pkgs.bibata-cursors;
            name = "Bibata Ice";
          };
          theme = {
            package = pkgs.materia-theme;
            name = "Materia-dark";
          };
          iconTheme = {
            package = pkgs.paper-icon-theme;
            name = "Paper";
          };
        };
      };
    };

    # # to allow virt-manager and stuff write their settings
    # services.dbus.packages = with pkgs; [ gnome3.dconf ];

    # services.gnome3.gnome-keyring.enable = true;

    # environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];
    # environment.variables.SOUND_THEME_FREEDESKTOP = "${pkgs.sound-theme-freedesktop}";

    #services.autorandr.enable = true;
  # } // (
  #   if (hasAttr "programs" options) then
  #     # COMPAT: NixOS >= 19.09
  #     { programs.seahorse.enable = true; }
  #   else
  #     # COMPAT: NixOS < 19.09
  #     { services.gnome3.seahorse.enable = true; }
  # );
}
