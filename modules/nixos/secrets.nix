{ lib, config, pkgs, agenix, ... }:

let
  inherit (lib) mkOption;
in {
  options = {
    _.secrets = mkOption {};
  };

  imports = [ agenix.nixosModules.age ];

  config = {

    environment.systemPackages = [
      pkgs.rage
      pkgs.age-plugin-yubikey
      (agenix.defaultPackage.${config.nixpkgs.system}.override { inherit (pkgs) nix; })
    ];

    _.secrets = {
      vlaci = import ../../secrets/vlaci.nix.age;
      work = import ../../secrets/work.nix.age;
    };
  };
}
