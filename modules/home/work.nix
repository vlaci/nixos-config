{ lib, pkgs, ... }:

lib.mkProfile "work" {
  home.packages = with pkgs; [
    slack
  ];
  _.persist = {
    directories = [
      ".config/Slack"
    ];
    files = [
      ".docker/config.json"
    ];
  };
}
