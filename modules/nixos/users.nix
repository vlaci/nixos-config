{ options, config, lib, secrets, ...}: with lib;

let
  defaultUsers = { root = { isNormalUser = false; }; };
  cfg = config._.users;
in {
  options._.users.defaultGroups = mkOption {
    type = with types; listOf str;
    default = [];
  };

  options._.users.users = mkOption {
    type = with types; attrsOf attrs;
  };

  options.users.users = mkOption {
    type = with types; attrsOf (submodule ({ name, config, ... }: {
      options = {
        extraGroups = mkOption {
          apply = groups: if config.isNormalUser then
            cfg.defaultGroups ++ groups
          else
            groups;
        };
        isAdmin = mkEnableOption "sudo access";
        home-manager = mkOption {
          type = mergedAttrs;
          default = {};
        };
      };
      config = {
        extraGroups = if config.isAdmin then ["wheel" ] else [];
      };
    }));
  };

  config = {
    users.mutableUsers = mkDefault false;
    _.users.users = defaultUsers;
    users.users = cfg.users;

    home-manager.users = mapAttrs (name: v: config.users.users.${name}.home-manager) cfg.users;
  };
}
