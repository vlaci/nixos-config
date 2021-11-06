{ config, options, lib, decrypt, ... }:

let
  inherit (lib) attrNames attrValues concatStringsSep genAttrs intersectLists mergedAttrs mkDefault mkIf mkOption types;

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
    home-manager.extraSpecialArgs = { inherit decrypt; };

    _.home-manager.forAllUsers.home.stateVersion = mkDefault "20.09";

    system.extraSystemBuilderCmds = ''
      mkdir -p $out/home-manager
    '' +
    concatStringsSep "\n" (map (cfg:
      "ln -sn ${cfg.home.activationPackage} $out/home-manager/${cfg.home.username}"
    ) (attrValues config.home-manager.users));
  };
}
