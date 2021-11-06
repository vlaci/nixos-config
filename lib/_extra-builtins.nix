{ exec, ...}:

{
  decrypt = { rage, writeText, identity, path }:
    exec [ "${rage}/bin/rage" "--decrypt" "--identity" (writeText "identity" identity) path ];
}
