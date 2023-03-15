{ stdenvNoCC, unzip }:

stdenvNoCC.mkDerivation {
  pname = "berkeley-mono-typeface";
  version = "1.009";

  src = ./berkeley-mono-typeface.zip;

  unpackPhase = ''
    runHook preUnpack

    ${unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 berkeley-mono/OTF/*.otf -t $out/share/fonts/truetype
    install -Dm644 berkeley-mono-variable/TTF/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
