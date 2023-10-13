{ lib, pkgs, ... }:

lib.mkProfile "work" {
  home.packages = with pkgs; [
    slack
  ];
}
