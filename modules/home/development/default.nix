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
      zlib
      icu69
      gnome.gnome-keyring
      libsecret
      desktop-file-utils
      xorg.xprop
      openssl
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
    languages = {
      language-server = {
        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = [ "--stdio" ];
          config.python.analysis = {
            autoSearchPaths = true;
            diagnosticMode = "workspace";
          };
        };
        rust-analyzer.config.checkOnSave = {
          command = "clippy";
        };
      };
      language = [
        {
          name = "python";
          language-servers = [ "pyright" ];
        }
      ];
    };
    settings = {
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
