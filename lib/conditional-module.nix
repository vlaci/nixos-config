{ config, options, lib }:

let
  inherit (lib) attrValues mkEnableOption mkIf mkMerge mkOption types;

  cfg = config._.conditionalModules;

  conditionalModule = types.submoduleWith {
    check = false;
    modules = [
      ({ name, config, ... }: {
        options = {
          # options = mkOption {
          #   type = types.attrs;
          #   default = { };
          # };
          config = mkOption {
            type = types.attrs;
          };
        };
        imports = [
          ({
            options = {
              enable = mkEnableOption name;
            };# // config.options;
            config = {};#mkIf config.enable config.config;
          })
        ];
      })
    ];
  };
in
{
  options = {
    _.conditionalModules = mkOption {
      #type = types.attrsOf conditionalModule;
      default = { };
    };
  };

  imports = attrValues cfg;
}
