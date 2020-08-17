{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware-customization.nix
  ];

  users.users.vlaci = {
    uid = 1000;
    initialHashedPassword = "$6$oFK5fkdOi.$viE6mLxHE4V/T3kiIpFsfuAbKVQ9UrZPRYrMtAPtS6Pe/i9XaUbE8Mb3D81OSXvNGd14waN2EXzqNDCxXdxVJ.";
  };
}
