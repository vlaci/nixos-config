{ pkgs, lib, ... }:

{
  imports = [
    (lib.mkProfile "libvirt" {
      home.packages = with pkgs; [
        virt-manager
      ];
      dconf.settings."org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    })
  ];
}
