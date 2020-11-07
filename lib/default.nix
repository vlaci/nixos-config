{ lib }: with lib;

{
  mkProfile = name: conf:
  {
    imports = [
      ({ config, ... }: let
        cfg = config._."${name}".enable;
        configAttr = if conf ? config then conf.config else (removeAttrs conf ["imports"]);
        importsAttr = if conf ? imports then conf.imports else [];
      in {
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
    merge = const (map (x: x.value));
  };
}
