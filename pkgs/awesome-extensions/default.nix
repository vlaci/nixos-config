{ lib, stdenv, luaPackages, pkgsrcs }:

let
  mkAwesomeExtension = { name, ... }@args:
    stdenv.mkDerivation ({
      installPhase =
        let
          inherit (luaPackages.lua) luaversion;
        in
        ''
          mkdir -p $out/share/lua/${luaversion}
          cp -a . $out/share/lua/${luaversion}/${name}
        '';
    } // args);
in
{
  awpwkb = mkAwesomeExtension {
    name = "awpwkb";
    inherit (pkgsrcs.awesome-awpwkb) src;
  };

  lain = mkAwesomeExtension {
    name = "lain";
    inherit (pkgsrcs.awesome-lain) src;
    patches = [ ./lain.patch ];
  };

  sharedtags = mkAwesomeExtension {
    name = "sharedtags";
    inherit (pkgsrcs.awesome-sharedtags) src;
  };
}
