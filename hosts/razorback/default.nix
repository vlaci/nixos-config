{ secrets, config, lib, pkgs, ... }:

{
  imports = [
  ];

  users.mutableUsers = false;

  _.defaultUser = secrets.users.default;
  _.home-manager.defaultUser = { secrets, ... }: {
    _.user = secrets.users.default;
    _.git.enable = true;
    _.tools.enable = true;
  };
}
