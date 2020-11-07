{ lib, ... }:

{
  options.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.attrs;
  };
  imports = [
    ./doom-emacs
    ./gui
    ./zsh
    ./git.nix
    ./gpg.nix
    ./programs.nix
    ./services.nix
    ./user.nix
  ];
}
