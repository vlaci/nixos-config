{ config, lib, ... }:

let
  inherit (lib) filterAttrs hasPrefix mapAttrsToList removePrefix;
in
{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  _.persist.directories =
    let
      home = "${config.home.homeDirectory}/";
    in
    mapAttrsToList (name: dir: removePrefix home dir)
      (filterAttrs (n: v: builtins.typeOf v == "string" && hasPrefix home v) config.xdg.userDirs);
}
