{ lib, ... }:

{
  imports = [
    ./development
    ./gui
    ./zsh
    ./emacs.nix
    ./email.nix
    ./git.nix
    ./gpg.nix
    ./homedir.nix
    ./keyboardio.nix
    ./programs.nix
    ./services.nix
    ./work.nix
  ];
}
