{ config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;
  cfg = config._.defaultUser;

  defaultUser = {
    options = {
      name = mkOption { type = types.str; };
      fullName = mkOption { type = types.str; };
      hashedPassword = mkOption { type = types.str; };
      email = mkOption { type = types.str; };
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
    };

    home-manager.users."${cfg.name}" = {
      programs.git = lib.mkDefault {
        userName = cfg.fullName;
        userEmail = cfg.email;
      };
    };
  };
}
