{ lib, pkgs, ... }:

lib.mkProfile "development"
{
  documentation.dev.enable = true;
  environment.enableDebugInfo = true;
  environment.systemPackages = with pkgs; [
    gdb
    man-pages
    man-pages-posix
  ];
}
