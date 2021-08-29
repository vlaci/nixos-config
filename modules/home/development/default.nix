{ lib, pkgs, ... }:

lib.mkProfile "development" {
  home.enableDebugInfo = true;
  home.packages = with pkgs; [
    vscode
    pandoc
    rnix-lsp
    rustup
    rust-analyzer
  ];
}
