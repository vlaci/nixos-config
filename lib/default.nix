{ lib }: with lib;

rec {
  mkProfile = name: conf:
    {
      imports = [
        ({ config, ... }:
          let
            cfg = config._."${name}".enable;
            configAttr = if conf ? config then conf.config else (removeAttrs conf [ "imports" ]);
            importsAttr = if conf ? imports then conf.imports else [ ];
          in
          {
            options = {
              _."${name}".enable = mkEnableOption name;
            };
            config = mkIf cfg configAttr;
            imports = importsAttr;
          })
      ];
    };

  mergedAttrs = mkOptionType {
    name = "mergedAttrs";
    merge = loc: defs: (getValues defs);
  };

  readModulesFromDir = dir:
    let
      contents = builtins.readDir dir;
      isModule = name: type: type == "directory" || type == "regular" && hasSuffix ".nix" name;
    in
    attrNames (filterAttrs isModule contents);

  importDir = dir:
    let
      modules = readModulesFromDir dir;
    in
    listToAttrs (map (f: nameValuePair (removeSuffix ".nix" f) (import (dir + "/${f}"))) modules);

  nixosConfigurations = import ./nixosConfigurations.nix;
}
