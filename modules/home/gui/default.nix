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
  };

  programs.rofi = {
    enable = true;
  };

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    xssLockExtraOptions = [
      "--notifier ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer"
      "--transfer-sleep-lock"
    ];
  };

  home.packages = with pkgs; [
    evince
    flameshot
    gimp
    vivaldi
  ];
}
