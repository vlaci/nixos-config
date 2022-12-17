{ config, lib, pkgs, ... }:

{
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "hu_HU.UTF-8";

  services.xserver.layout = "altgr-weur,hu";
  #services.xserver.xkbVariant = "altgr-intl,";
  services.xserver.xkbOptions = "grp:ctrls_toggle, compose:rctrl, caps:escape";
  services.xserver.extraLayouts."altgr-weur" = {
    description = "English (Western European AltGr dead keys)";
    languages = [ "eng" ];
    symbolsFile =
      pkgs.runCommand "altgr-weur-mod" { src = ./keymaps/symbols/altgr-weur; } ''
        sed $src  -E -e 's/\b(o|u)circumflex/\1doubleacute/g' > $out
      '';
  };
}
