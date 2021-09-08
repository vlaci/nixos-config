{ config, lib, pkgs, ... }:

lib.mkProfile "gui" {
  imports = [
    ./awesome
    ./herbstluftwm
    ./theme
  ];

  services.picom = {
    enable = true;
    experimentalBackends = true;
    extraOptions = ''
      blur-method = "dual_kawase";
    '';
    opacityRule = [
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
  programs.ssh.extraConfig = ''
    SetEnv TERM=xterm-256color
  '';

  programs.rofi = {
    enable = true;
  };

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    xautolockExtraOptions = [
      "-notify 15"
      "-notifier 'XSECURELOCK_DIM_TIME_MS=10000 XSECURELOCK_WAIT_TIME_MS=5000 ${pkgs.xsecurelock}/libexec/xsecurelock/until_nonidle ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer'"
    ];
    xssLockExtraOptions = [
      "--notifier ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer"
      "--transfer-sleep-lock"
    ];
  };

  services.redshift = {
    enable = true;
    provider = "geoclue2";
    temperature.night = 3200;
  };

  home.packages = with pkgs; [
    evince
    flameshot
    gimp
    vivaldi
  ];
}
