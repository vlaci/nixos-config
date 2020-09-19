{ config, lib, ... }:

let
  inherit (lib) mkDefault mkOption types;
  cfg = config._.user;

  user = {
    options = {
      name = mkOption { type = types.str; };
      fullName = mkOption { type = types.str; };
      hashedPassword = mkOption { type = types.str; };
      email = mkOption { type = types.str; };
      authorizedKeys = mkOption { type = types.listOf types.str; };
    };
  };
in
{
  options = {
    _.user = mkOption {
      type = types.submodule user;
    };
  };

  config = {
    programs.git = mkDefault {
      userName = cfg.fullName;
      userEmail = cfg.email;
    };
  };
}
