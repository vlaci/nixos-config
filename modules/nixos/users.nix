{ options, config, lib, secrets, ... }: with lib;

let
  defaultUsers = { root = { isNormalUser = false; }; };
  cfg = config._.users;
in
{
  options._.users.defaultGroups = mkOption {
    type = with types; listOf str;
    default = [ ];
  };

  options._.users.users = mkOption {
    description = "Wrapper around `users.users` with sane defaults.";
    type = with types; attrsOf (submodule ({ options, config, ... }: {
      freeformType = attrsOf anything;
      options = {
        extraGroups = mkOption {
          apply = groups:
            if config.isNormalUser then
              cfg.defaultGroups ++ groups
            else
              groups;
        };
        isAdmin = mkEnableOption "sudo access";
        home-manager = mkOption {
          type = mergedAttrs;
          default = { };
        };

        forwarded = mkOption { };
      };
      config = {
        isNormalUser = mkDefault true;
        extraGroups = if config.isAdmin then [ "wheel" ] else [ ];
        forwarded = filterAttrs (n: v: !(options ? ${n}) || n == "extraGroups") config;
      };
    }));
    default = { };
  };


  config = {
    users.mutableUsers = mkDefault false;
    _.users.users = defaultUsers;
    users.users = mapAttrs (n: v: v.forwarded) cfg.users;

    home-manager.users = mapAttrs (n: v: { imports = v.home-manager; }) cfg.users;
  };
}
