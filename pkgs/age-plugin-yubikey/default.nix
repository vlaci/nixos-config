{ lib, stdenv, pkgsrcs, rustPlatform, fetchFromGitHub, installShellFiles, pkg-config, pcsclite }:

rustPlatform.buildRustPackage rec {
  inherit (pkgsrcs.age-plugin-yubikey) pname version src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];

  buildInputs = [ pcsclite ];

  postBuild = ''
    cargo run --example generate-docs
  '';

  postInstall = ''
    installManPage target/manpages/*
  '';
}
