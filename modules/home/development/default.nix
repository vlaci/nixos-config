{ lib, pkgs, ... }:

lib.mkProfile "development" {
  home.enableDebugInfo = true;
  home.packages = with pkgs; [
    julia-bin
    (vscode.fhsWithPackages (pkgs: with pkgs; [
      zsh
      gcr liburcu openssl krb5 zlib icu gnome3.gnome-keyring libsecret desktop-file-utils xorg.xprop
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
    tcpdump
    wireshark-qt
  ];
}
