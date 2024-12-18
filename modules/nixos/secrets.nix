{
  lib,
  config,
  pkgs,
  agenix,
  ...
}:

let
  inherit (lib) fileContents hasInfix mkOption;

  isEncrypted =
    src:
    hasInfix "age encrypted file" (
      fileContents (
        pkgs.runCommandLocal "is-encrypted"
          {
            inherit src;
            buildInputs = [ pkgs.file ];
          }
          ''
            file -b $src > $out
          ''
      )
    );
  tryImport =
    path:
    if isEncrypted path then
      { available = false; }
    else
      {
        available = true;
        value = import path;
      };
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
  };
}
