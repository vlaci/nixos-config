{ lib, mkDerivation, luaPackages, pkgsrcs }:

let
  mkAwesomeExtension = { name, ... }@args:
    mkDerivation ({
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
    src = pkgsrcs.awesome-awpwkb;
  };

  lain = mkAwesomeExtension {
    name = "lain";
    src = pkgsrcs.awesome-lain;
    patches = [ ./lain.patch ];
  };

  sharedtags = mkAwesomeExtension {
    name = "sharedtags";
    src = pkgsrcs.awesome-sharedtags;
  };
}
