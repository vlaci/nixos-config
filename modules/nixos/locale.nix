{ config, lib, pkgs, ... }:

{
  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;
  i18n.defaultLocale = "hu_HU.UTF-8";

  environment.systemPackages = [ pkgs.colemak-dh ];

  services.xserver.layout = "col-lv,altgr-weur,us,hu";
  services.xserver.xkbOptions = "grp:alt_altgr_toggle, compose:rctrl, caps:escape";
  services.xserver.extraLayouts."col-lv" = {
    description = "English (Colemak)";
    languages = [ "eng" ];
    symbolsFile = ./keymaps/symbols/col-lv;
  };
  services.xserver.extraLayouts."altgr-weur" = {
    description = "English (Western European AltGr dead keys)";
    languages = [ "eng" ];
    symbolsFile =
      pkgs.runCommand "altgr-weur-mod" { src = ./keymaps/symbols/altgr-weur; } ''
        sed $src  -E -e 's/\b(o|u)circumflex/\1doubleacute/g' > $out
      '';
  };
}
