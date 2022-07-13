{ config, nixosConfig, lib, pkgs, ... }:

let
  isWayland = nixosConfig._.gui.wayland.enable;
in lib.mkProfile "gui" {
  imports = [
    ./awesome
    ./herbstluftwm
    ./theme
    ./sway.nix
  ];

  services.picom = {
    enable = !isWayland;
    experimentalBackends = true;
    settings.blur-method = "dual_kawase";
    opacityRules = [
      "90:class_g = 'kitty'"
    ];
    vSync = true;
  };

  programs.firefox.enable = true;
  programs.kitty = {
    enable = true;
    keybindings."ctrl+shift+p>n" = ''kitten hints --type=linenum --linenum-action=window bat --pager "less --RAW-CONTROL-CHARS +{line}" -H {line} {path}'';
    settings.select_by_word_characters = "@-./_~?&%+#";
  };
  programs.zsh.initExtra = ''
    ssh() {
      TERM=''${TERM/-kitty/-256color} command ssh "$@"
    }
  '';

  programs.rofi = {
    enable = true;
  };

  services.screen-locker = {
    enable = !isWayland;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    xautolock.extraOptions = [
      "-notify 15"
      "-notifier 'XSECURELOCK_DIM_TIME_MS=10000 XSECURELOCK_WAIT_TIME_MS=5000 ${pkgs.xsecurelock}/libexec/xsecurelock/until_nonidle ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer'"
    ];
    xss-lock.extraOptions = [
      "--notifier ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer"
      "--transfer-sleep-lock"
    ];
  };

  services.redshift = {
    enable = !isWayland;
    provider = "geoclue2";
    temperature.night = 3200;
  };

  services.syncthing.enable = true;

  home.keyboard = null;

  home.packages = with pkgs; [
    evince
    flameshot
    gimp
    signal-desktop
    vivaldi
  ];

  services.flameshot.enable = true;
}
