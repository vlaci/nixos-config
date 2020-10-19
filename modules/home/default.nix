{ lib, ... }:

{
  options.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.attrs;
  };

  config = {
    _module.args = {
      secrets = import ../../secrets;
    };
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
