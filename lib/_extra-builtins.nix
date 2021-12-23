{ exec, ...}:

{
  decrypt = { rage, identities, lib, path }:
    let identities' = lib.concatMap (i: ["--identity" i]) identities;
    in
      exec ([ "${rage}/bin/rage" "--decrypt"] ++ identities' ++ [ path ]);
}
