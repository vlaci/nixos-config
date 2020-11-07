{ lib, pkgs, ... }:

lib.mkProfile "networkmanager" {
  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    dns = "dnsmasq";

    packages = [
      pkgs.dhcpcd
    ];
  };
}
