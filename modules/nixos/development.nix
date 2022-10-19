{ lib, pkgs, ... }:

lib.mkProfile "development"
{
  documentation.dev.enable = true;
  environment.enableDebugInfo = true;
  environment.systemPackages = with pkgs; [
    gdb
    man-pages
    man-pages-posix
  ];

  nixpkgs.overlays = [
    (self: super: {
      ocaml = super.ocaml.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          self.makeWrapper
        ];
        postInstall = (old.postInstall or "") + ''
          for bin in $out/bin/*; do
            wrapProgram $bin --prefix PATH : ${self.stdenv.cc}/bin
          done
        '';
      });
    })
  ];
}
