{ rules, pkgs }:

let
  inherit (pkgs) callPackage;
  inherit (pkgs.lib) attrValues filterAttrs hasSuffix info;
  inherit (builtins) extraBuiltins head length;
  decrypt = path:
    let
      decrypt' = callPackage extraBuiltins.decrypt;
      matchedSecrets = filterAttrs (n: _: hasSuffix n path) rules;
      secretVals = attrValues matchedSecrets;
      secret = head secretVals;
    in
      assert ((length secretVals) == 1);
      info "==> Decrypting secret '${path}' using ${toString secret.identities}..."
      decrypt' { inherit (secret) identities; inherit path; };
in
{
  inherit decrypt;
}
