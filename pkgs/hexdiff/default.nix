{ mkDerivation, pkgsrcs }:

mkDerivation {
  src = pkgsrcs.hexdiff;
  buildPhase = ''
    $CC hexdiff.c -o hexdiff
  '';
  installPhase = ''
    mkdir -p $out/bin
    install hexdiff $out/bin
  '';
}
