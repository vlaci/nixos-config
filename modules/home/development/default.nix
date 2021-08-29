{ lib, pkgs, ... }:

lib.mkProfile "development" {
  home.enableDebugInfo = true;
  home.packages = with pkgs; [
    vscode
    openssl
    pandoc
    rnix-lsp
    rustup
    rust-analyzer
  ];
}
