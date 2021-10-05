{ config, options, lib, secrets, ... }:

let
  inherit (lib) attrNames genAttrs intersectLists mapAttrs mergedAttrs mkDefault mkIf mkOption types;

  cfg = config._.home-manager;

  overrideHmModule = types.submoduleWith {
    modules =
      let
        nixosOptions = options;
      in
      cfg.forAllUsers ++ [
        ({ options, ... }: {

          _ = genAttrs
            (
              intersectLists
                (attrNames options._)
                (attrNames nixosOptions._)
            )
            (name: { enable = mkDefault config._.${name}.enable; });
        })
      ];
  };
in
{
  options = {
    home-manager.users = mkOption { type = types.attrsOf overrideHmModule; };
    _.home-manager.forAllUsers = mkOption { type = mergedAttrs; default = { }; };
  };
  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = { inherit secrets; };
  };
}
