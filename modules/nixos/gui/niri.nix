{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config._.gui.niri;
in
{
  options = {
    _.gui.niri.enable = mkEnableOption "niri";
  };
  config = mkIf cfg.enable {
    programs.niri.enable = true;
  };
}
