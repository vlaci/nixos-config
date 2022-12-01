{ pkgs, lib, ... }:

lib.mkProfile "keyboardio" {
  services.udev.packages = [ pkgs.chrysalis ];
}
