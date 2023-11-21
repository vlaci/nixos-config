{ lib, ... }:

{
  imports = [
    ./development
    ./gui
    ./nushell
    ./zsh
    ./emacs.nix
    ./email.nix
    ./git.nix
    ./gpg.nix
    ./homedir.nix
    ./jujutsu.nix
    ./keyboardio.nix
    ./persist.nix
    ./programs.nix
    ./services.nix
    ./work.nix
  ];
}
