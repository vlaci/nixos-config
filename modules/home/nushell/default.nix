{ pkgs, lib, ... }:

lib.mkProfile "nushell" {
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };
}
