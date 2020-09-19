{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  cfg = config._.defaultUser;

  defaultUser = {
    options = {
      name = mkOption { type = types.str; };
      fullName = mkOption { type = types.str; };
      hashedPassword = mkOption { type = types.str; };
      email = mkOption { type = types.str; };
      authorizedKeys = mkOption { type = types.listOf types.str; };
      extraGroups = mkOption { type = types.listOf types.str; default = [ ]; };
    };
  };
in
{
  options = {
    _.defaultUser = mkOption {
      type = types.submodule defaultUser;
    };
  };

  config = {
    users.users."${cfg.name}" = {
      createHome = true;
      uid = 1000;
      description = cfg.fullName;
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
      shell = pkgs.zsh;
    };
  };
}
