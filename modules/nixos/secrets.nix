{ lib, config, pkgs, agenix, ... }:

let
  inherit (builtins) pathExists;
  inherit (lib) fileContents hasSuffix mkOption;

  isEncrypted = src: hasSuffix " data" (fileContents (pkgs.runCommandLocal "is-encrypted"
    {
      inherit src;
      buildInputs = [ pkgs.file ];
    } ''
    file $src > $out
  ''
  ));
  tryImport = path:
    if isEncrypted path then
      { available = false; }
    else
      { available = true; value = import path; }
  ;
in
{
  options = {
    _.secrets = mkOption { };
  };

  imports = [ agenix.nixosModules.age ];

  config = {

    environment.systemPackages = [
      pkgs.rage
      pkgs.age-plugin-yubikey
      (agenix.packages.${config.nixpkgs.system}.default.override { inherit (pkgs) nix; })
    ];

    _.secrets = {
      vlaci = tryImport ../../secrets/vlaci.nix.age;
      work = tryImport ../../secrets/work.nix.age;
    };

    # agenix may use personal SSH private keys
    fileSystems."/home".neededForBoot = true;
  };
}
