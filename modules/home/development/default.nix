{ lib, pkgs, ... }:

lib.mkProfile "development" {
  home.packages = with pkgs; [
    vscode
    pandoc
    rnix-lsp
    rustup
    rust-analyzer
  ];
}
