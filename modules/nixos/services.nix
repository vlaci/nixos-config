{ lib, ... }:

{
  # smart card (+yubikey)
  services.pcscd.enable = true;

  imports = [
    (
      lib.mkProfile "sshd" {
        services.openssh = {
          enable = true;
          forwardX11 = true;
          passwordAuthentication = true;
          permitRootLogin = "no";
          startWhenNeeded = true;
        };
      })
  ];
}
