{ lib, ... }:

lib.mkProfile "cachix" {
  imports = [ ./cachix.nix ];
}
