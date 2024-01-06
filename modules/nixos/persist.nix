{ lib, config, ... }:

let
  cfg = config._.persist;
  inherit (lib) filterAttrs mapAttrs mkEnableOption mkIf mkMerge mkOption pipe types;
in
{
  options._.persist = {
    enable = mkEnableOption "persist";
    root = mkOption { default = "/.persistent"; };
    directories = mkOption { type = with types; listOf anything; default = [ ]; };
  };

  options._._users.users = mkOption {
    type = with types; attrsOf (submodule ({ options, config, ... }: {
      options.persist.directories = mkOption { type = listOf anything; default = [ ]; };
    }));
  };

  options.fileSystems = mkOption {
    type = with lib.types; attrsOf (submodule ({ config, ... }: {
      options.neededForBoot = mkOption {
        apply = orig: (config.mountPoint == cfg.root || lib.hasPrefix "${cfg.root}/" config.mountPoint) || orig;
      };
    }));
  };

  config = mkMerge [
    {
      _.users.ignoredAttrs = [ "persist" ];
    }
    (mkIf cfg.enable {
      programs.fuse.userAllowOther = true;
      environment.persistence.${cfg.root} = {
        hideMounts = true;
        directories = [
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/log"
        ] ++ cfg.directories;
        users = pipe config._.users.users [
          (filterAttrs (n: v: v ? persist))
          (mapAttrs (n: v: { inherit (v.persist) directories; }))
        ];
      };
    })
  ];
}
