{ lib, ... }:

lib.mkProfile "git" {
  programs.git = {
    enable = true;
  };
}
