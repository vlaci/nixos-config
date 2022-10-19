{ lib, pkgs, ... }:

lib.mkProfile "development" {
  home.enableDebugInfo = true;
  home.packages = with pkgs; [
    julia-bin
    (vscode.fhsWithPackages (pkgs: with pkgs; [
      zsh
      # for live share
      gcr
      liburcu
      krb5
      openssl_1_1
      zlib
      icu69
      gnome.gnome-keyring
      libsecret
      desktop-file-utils
      xorg.xprop
      openssl.dev
      pkg-config
      binutils
      zlib.dev
      neovim
      gcc
    ]))
    openssl
    pandoc
    rnix-lsp
    cargo-edit
    clang
    lldb
    nodejs
    dune_3
    ocaml
    ocamlPackages.utop
    rustup
    rust-analyzer
    mitmproxy
    sqlite-interactive
    tcpdump
    unixtools.xxd # hexdump
    litecli
    visidata
    wireshark-qt
  ];

  home.file.".sqliterc".text = ''
    .mode column
    .timer on
    .changes on
    .nullvalue NULL
  '';
}
