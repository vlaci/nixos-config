{ lib, config, ... }:

lib.mkProfile "work" {
  age.secrets."email-lva.pem" = {
    file = ../../secrets/work/email-lva.pem.age;
    owner = "vlaci";
  };

  age.secrets."email-lva.pfx" = {
    file = ../../secrets/work/email-lva.pfx.age;
    owner = "vlaci";
  };

  age.secrets."vpn.cert.pem" = {
    file = ../../secrets/work/vpn.cert.pem.age;
  };

  age.secrets."vpn.key.pem" = {
    file = ../../secrets/work/vpn.key.pem.age;
  };

  security.pki.certificates = config._.secrets.work.certificates;
  _.email.work.enable = true;
}
