{ lib, config, pkgs, ... }:

lib.mkProfile "networkmanager" {
  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    dns = "dnsmasq";
  };

  environment.systemPackages = with pkgs; ([
    pkgs.dhcpcd
  ] ++ lib.optionals config._.gui.enable [ networkmanagerapplet ]);

  _.users.defaultGroups = [ "networkmanager" ];
}
