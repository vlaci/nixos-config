{ secrets, config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware-customization.nix
  ];

  users.mutableUsers = false;

  _.defaultUser = secrets.users.default;
  _.home-manager.defaultUser = { pkgs, ... }: {
    programs.git = {
      enable = true;
    };

    home.packages = with pkgs; [
      bind
      jetbrains.pycharm-community
      transmission-remote-gtk
      pkgs._.mozilla.latest.firefox-bin
    ];
  };

  environment.systemPackages = [
  ];
}
