{ config, lib, pkgs, ... }:

lib.mkProfile "gui" {
  imports = [
    ./colors.nix
    ./herbstluftwm
  ];
  xsession = {
    enable = true;
    scriptPath = ".xsession-hm";
    windowManager.command = "herbstluftwm";
  };

  services.picom = {
    enable = true;
    package = pkgs.picom.overrideAttrs (super: rec {
      version = "9";
      src = pkgs.fetchFromGitHub {
        owner  = "yshui";
        repo   = "picom";
        rev    = "d00c1c7a1d32aa66bcfa5a0bb3fd6ce0fffb4fb9";
        sha256 = "sha256-DAsPb9jyA0XgvANpoT/nHtgSsiol0IkuKgzt69MHygY=";
        fetchSubmodules = true;
      };
    });
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
}
