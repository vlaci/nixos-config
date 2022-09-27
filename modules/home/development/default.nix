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
      openssl
      krb5
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
    rustup
    rust-analyzer
    mitmproxy
    sqlite-interactive
    tcpdump
    unixtools.xxd # hexdump
    wireshark-qt
  ];

  home.file.".sqliterc".text = ''
    .mode column
    .timer on
    .changes on
    .nullvalue NULL
  '';
}
