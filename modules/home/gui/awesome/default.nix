{ config, lib, pkgs, ... }:

lib.mkProfile "awesome" {
  home.file = {
    ".config/awesome".source = ./config;
  };

  home.packages = with pkgs; [
    scrot
    material-design-icons
  ];

  xsession = {
    enable = true;
    scriptPath = ".xsession-hm";
    windowManager.awesome =
      {
        enable = true;
        luaModules = with pkgs.awesome-extensions; [ awpwkb lain sharedtags ];
      };
  };
}
