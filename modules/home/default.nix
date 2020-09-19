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
    ./git.nix
    ./tools.nix
    ./user.nix
    ./zsh
  ];
}
