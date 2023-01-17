{ lib, stdenv, pkgsrcs, rustPlatform, fetchFromGitHub, installShellFiles, pkg-config, pcsclite }:

rustPlatform.buildRustPackage rec {
  inherit (pkgsrcs.age-plugin-yubikey) pname version src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";

    outputHashes = {
      "yubikey-0.7.0" = "sha256-H8qFvbsArqnJbFUww3X3aUg7cvH0dEJrPs3a+s6y8QE=";
    };
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
