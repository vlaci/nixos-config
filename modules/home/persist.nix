{ lib, config, nixosConfig, ... }:

let
  cfg = config._.persist;
  inherit (lib) mkEnableOption mkIf mkOption types;
in
{
  options._.persist = {
    enable = mkOption { default = nixosConfig._.persist.enable; type = types.bool; };
    root = mkOption { default = "${nixosConfig._.persist.root}${config.home.homeDirectory}"; };
    directories = mkOption { type = with types; listOf anything; default = [ ]; };
    files = mkOption { type = with types; listOf anything; default = [ ]; };
  };

  config = mkIf cfg.enable {
    home.persistence.${cfg.root} = {
      allowOther = true;
      inherit (cfg) directories files;
    };
  };
}
