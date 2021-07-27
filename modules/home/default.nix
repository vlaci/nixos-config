{ lib, ... }:

{
  imports = [
    ./development
    ./doom-emacs
    ./gui
    ./zsh
    ./emacs.nix
    ./git.nix
    ./gpg.nix
    ./programs.nix
    ./services.nix
  ];
}
