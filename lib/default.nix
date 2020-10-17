{ lib }:

let
  inherit (lib) mkIf mkEnableOption optionals;
in {
  mkProfile = name: conf:
  {
    imports = [
      ({ config, ... }: let
        cfg = config._."${name}".enable;
        configAttr = conf;
        importsAttr = [];
      in {
        options = {
          _."${name}".enable = mkEnableOption name;
        };
        config = mkIf cfg configAttr;
        imports = [];
      })
    ];
  };
}
