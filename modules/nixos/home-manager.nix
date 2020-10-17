{ config, options, lib, ... }:

let
  inherit (lib) const mkIf mkOption mkOptionType types;

  cfg = config._.home-manager;

  overrideHmModule = types.submoduleWith {
    modules =
      cfg.forAllUsers;
  };

  mergedAttrs = mkOptionType {
    name = "mergedAttrs";
    merge = const (map (x: x.value));
  };
in
{
  options = {
    home-manager.users = mkOption { type = types.attrsOf overrideHmModule; };
    _.home-manager.forAllUsers = mkOption { type = mergedAttrs; default = {}; };
    _.home-manager.defaultUser = mkOption { type = mergedAttrs; default = {}; };
  };
  config = mkIf options._.defaultUser.isDefined {
    home-manager.users."${config._.defaultUser.name}" = {
      imports = cfg.defaultUser;
    };
  };
}
