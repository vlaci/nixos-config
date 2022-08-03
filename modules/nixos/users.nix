{ options, config, lib, decrypt, ... }: with lib;

let
  cfg = config._.users;
  vlaci = config._.secrets.vlaci;
in
{
  options._.users.defaultGroups = mkOption {
    type = with types; listOf str;
    default = [ ];
  };

  options._.users.enable = mkOption {
    type = types.bool;
    default = true;
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


  config = mkIf cfg.enable {
    users.mutableUsers = false;
    users.allowNoPasswordLogin = !vlaci.available && (warn "Secrets are not available, users won't be able to log in!" true);
    users.users = mapAttrs (n: v: v.forwarded) cfg.users;
    home-manager.users = mapAttrs (n: v: { imports = v.home-manager; }) cfg.users;

    age.identityPaths = options.age.identityPaths.default ++ [ "/home/vlaci/.ssh/id_ed25519" ];

    _.users.users.root = { isNormalUser = false; };
    _.users.users.vlaci = mkIf vlaci.available {
      description = vlaci.value.fullName;
      initialHashedPassword = vlaci.value.passwordHash;
      openssh.authorizedKeys.keys = vlaci.value.authorizedKeys;
      home-manager = {
        home.file.".config/Yubico/u2f_keys".text = ''
          vlaci:${concatStringsSep ":" vlaci.value.u2fKeys}
        '';
      };
    };
  };
}
