{ lib, ... }:

lib.mkProfile "git" {
  programs.git = {
    enable = true;
    delta.enable = true;
  };
}
