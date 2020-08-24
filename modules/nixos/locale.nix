{ config, lib, pkgs, ... }:

{
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "hu_HU.UTF-8";

  services.xserver.layout = "us,hu";
  services.xserver.xkbOptions = "grp:lalt_lshift_toggle, compose:rctrl-altgr, caps:escape";
}
