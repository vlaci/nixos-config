{
  lib,
  config,
  pkgs,
  ...
}:

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
    programs.niri.package = pkgs.niri-unstable;
  };
}
