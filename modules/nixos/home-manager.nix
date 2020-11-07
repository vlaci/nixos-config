{ config, options, lib, ... }:

let
  inherit (lib) attrNames genAttrs intersectLists mergedAttrs mkIf mkOption types;

  cfg = config._.home-manager;

  overrideHmModule = types.submoduleWith {
    modules = let
      nixosOptions = options;
    in
      cfg.forAllUsers ++ [({ options, ... }: {

        _ = genAttrs (
          intersectLists
            (attrNames options._)
            (attrNames nixosOptions._)
          ) (name: config._.${name});
      })];
  };
in
{
  options = {
    home-manager.users = mkOption { type = types.attrsOf overrideHmModule; };
    _.home-manager.forAllUsers = mkOption { type = mergedAttrs; default = {}; };
  };
}
