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
      util-linux
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

  programs.helix = {
    enable = true;
    languages = [
      {
        name = "python";
        language-server = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = [ "--stdio" ];
        };
        config.python.analysis = {
          autoSearchPaths = true;
          diagnosticMode = "workspace";
        };
      }
      {
        name = "rust";
        config.checkOnSave = {
          command = "clippy";
        };
      }
    ];
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
      };
    };
  };
}
