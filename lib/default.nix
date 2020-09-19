{ lib }:

let
  inherit (lib) mkIf mkEnableOption;
in {
  mkProfile = name: conf:
  {
    imports = [
      ({ config, ... }: let
        cfg = config._."${name}".enable;
      in {
        options = {
          _."${name}".enable = mkEnableOption name;
        };
        config = mkIf cfg conf;
      })
    ];
  };
}
