@help:
    just --list --list-heading $'Available commands:\n'

# Setup repository for development
dev:
    git config --local include.path .gitconfig

update-pkgs:
    cd pkgs && nix flake update
    nix flake lock --update-input pkgsrcs

repl:
    nix run ".#repl"

build-host host:
    nix build --impure --expr 'with builtins.getFlake (toString ./.); nixosConfigurations."{{ host }}".config.system.build.toplevel'

build-hosts:
    nix build --dry-run --impure --expr "with builtins.getFlake (toString ./.); lib.mapAttrsToList (n: v: v.config.system.build.toplevel) nixosConfigurations"
    nix build --impure --expr "with builtins.getFlake (toString ./.); lib.mapAttrsToList (n: v: v.config.system.build.toplevel) nixosConfigurations"

build-pkgs:
    nix build --dry-run --impure --expr "with builtins.getFlake (toString ./.); lib.recurseIntoAttrs packages.x86_64-linux"
    nix build --impure --expr "with builtins.getFlake (toString ./.); lib.recurseIntoAttrs packages.x86_64-linux"
