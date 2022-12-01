{ pkgs, lib, ... }:

lib.mkProfile "keyboardio" {
  home.packages = [ pkgs.chrysalis ];
}
