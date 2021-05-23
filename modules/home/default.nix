{ lib, ... }:

{
  imports = [
    ./development
    ./doom-emacs
    ./gui
    ./zsh
    ./git.nix
    ./gpg.nix
    ./programs.nix
    ./services.nix
  ];
}
