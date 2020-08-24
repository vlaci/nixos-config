user:
{ config, options, lib, ... }:

let
  inherit (lib) mkOption types;

  cfg = config.home-manager;

  overrideHmModule = types.submodule ({ name, ... }: {
    cfg.users.${name}.stateVersion = cfg.stateVersion;
  });
in {
  options = {
    home-manager.users = mkOption { type = types.attrsOf overrideHmModule; };
    home-manager.stateVersion = mkOption { type = types.str; default = "20.09"; };
  };
  config = {
  };
}
