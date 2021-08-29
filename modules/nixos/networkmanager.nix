{ lib, config, pkgs, ... }:

lib.mkProfile "networkmanager" {
  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    dns = "dnsmasq";

    packages = with pkgs; ([
      pkgs.dhcpcd
    ] ++ lib.optionals config._.networkmanager.enable [ networkmanagerapplet ]);
  };
  _.users.defaultGroups = [ "networkmanager" ];
}
