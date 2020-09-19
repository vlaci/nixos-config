{ config, options, lib }:

let
  inherit (lib) forEach mkEnableOption mkIf mkMerge mkOption types;

  conditionalModule = types.submoduleWith {
    modules = [
      { name, ...}: {
        options = {
          options = mkOption {
            type = types.attrs;
          };
          config = mkOption {
            type = types.attrs;
          };
        };
        config = {
          options = {
            enable = mkEnableOption name;
          };
          config = mkIf config.enable config.config;
        };
      }
    ];
  };
in
{
  options = {
    _.conditionalModules = mkOption {
      type = conditionalModule;
    };

    config = mkMerge forEach config._.conditionalModules (m:
      m.config
    );
  };
}
