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
    ./homedir.nix
    ./programs.nix
    ./services.nix
  ];
}
