{ lib, ... }:

{
  imports = [
    ./development
    ./doom-emacs
    ./gui
    ./zsh
    ./emacs.nix
    ./email.nix
    ./git.nix
    ./gpg.nix
    ./homedir.nix
    ./programs.nix
    ./services.nix
  ];
}
