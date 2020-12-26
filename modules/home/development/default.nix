{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vscode
    python39
    julia
    pandoc
    rustup
  ];
}
