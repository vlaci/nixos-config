{ lib, config, ... }:

let
  cfg = config._.persist;
  inherit (lib) mkEnableOption mkIf mkOption types;
in
{
  options._.persist = {
    enable = mkEnableOption "persist";
    root = mkOption { default = "/.persistent"; };
    directories = mkOption { type = with types; listOf anything; default = [ ]; };
  };

  config = mkIf cfg.enable {
    programs.fuse.userAllowOther = true;
    environment.persistence.${cfg.root} = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/log"
      ] ++ cfg.directories;
    };
  };
}
