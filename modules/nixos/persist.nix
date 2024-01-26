{ lib, config, ... }:

let
  cfg = config._.persist;
  inherit (lib) filterAttrs mapAttrs mkEnableOption mkIf mkMerge mkOption pipe types;
  persistOpts = with types; submodule ({ options, config, ... }: {
    options.persist.directories = mkOption { type = listOf anything; default = [ ]; };
  });

in
{
  options._.persist = {
    enable = mkEnableOption "persist";
    root = mkOption { default = "/persist"; };
    directories = mkOption { type = with types; listOf anything; default = [ ]; };
  };

  options._.users.users = mkOption {
    type = with types; attrsOf persistOpts;
  };

  options._.users.forAllUsers = mkOption {
    type = persistOpts;
  };

  options.fileSystems = mkOption {
    type = with types; attrsOf (submodule ({ config, ... }: {
      options.neededForBoot = mkOption {
        apply = orig: (config.mountPoint == cfg.root || lib.hasPrefix "${cfg.root}/" config.mountPoint) || orig;
      };
    }));
  };

  config = (mkIf cfg.enable {
    programs.fuse.userAllowOther = true;
    environment.persistence.${cfg.root} = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/log"
      ] ++ cfg.directories;
      users = pipe config._.users.users [
        (filterAttrs (n: v: n != "root"))
        (mapAttrs (n: v: v.persist or { }))
      ];
    };
  });
}
