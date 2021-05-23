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
