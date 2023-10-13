{ lib, config, ... }:

let
  inherit (config._.secrets) work;
in
lib.mkProfile "work" (lib.mkIf work.available {

  age.secrets."docker-client.key" = {
    file = ../../secrets/work/client.pem.age;
    path = "/etc/docker/certs.d/${config._.secrets.vlaci.value.docker.work.registry}/client.key";
  };

  age.secrets."docker-client.cert" = {
    file = ../../secrets/work/client.pem.age;
    path = "/etc/docker/certs.d/${config._.secrets.vlaci.value.docker.work.registry}/client.cert";
  };

  age.secrets."work.certkey" = {
    file = ../../secrets/work/client.pem.age;
    owner = "vlaci";
  };

  security.pki = {
    certificates = work.value.certificates;
  };
  _.email.work.enable = true;
})
