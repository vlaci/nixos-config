{ pkgs, lib, ... }:

{
  # more convenient shell environments
  services.lorri.enable = true;

  imports = [
    (lib.mkProfile "libvirt" {
      home.packages = with pkgs; [
        virt-manager
      ];
    })
  ];
}
