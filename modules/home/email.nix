{ lib, pkgs, ... }:

lib.mkProfile "email" {
  programs.mbsync = {
    enable = true;
  };

  services.mbsync = {
    enable = false;
  };

  programs.msmtp = {
    enable = true;
  };

  programs.mu = {
    enable = true;
  };
}
