{ stdenv, pkgsrcs }:

stdenv.mkDerivation {
  inherit (pkgsrcs.hexdiff) pname version src;
  buildPhase = ''
    $CC hexdiff.c -o hexdiff
  '';
  installPhase = ''
    mkdir -p $out/bin
    install hexdiff $out/bin
  '';
}
