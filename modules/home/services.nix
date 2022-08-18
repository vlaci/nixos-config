{ pkgs, lib, ... }:

{
  imports = [
    (lib.mkProfile "libvirt" {
      home.packages = with pkgs; [
        virt-manager
      ];
    })
  ];
}
