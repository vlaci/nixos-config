{ lib, config, ... }:

let
  inherit (config._.secrets) work;
in
lib.mkProfile "work" (
  lib.mkIf work.available {

    age.secrets =
      (lib.pipe config._.secrets.vlaci.value.docker.work.registries [
        (lib.concatMap (url: [
          {
            name = "docker-client-${url}.key";
            value = {
              file = ../../secrets/work/client.pem.age;
              path = "/etc/docker/certs.d/${url}/client.key";
            };
          }
          {
            name = "docker-client-${url}.cert";
            value = {
              file = ../../secrets/work/client.pem.age;
              path = "/etc/docker/certs.d/${url}/client.cert";
            };
          }
        ]))
        builtins.listToAttrs
      ])
      // {
        "work.certkey" = {
          file = ../../secrets/work/client.pem.age;
          owner = "vlaci";
        };
      };

    security.pki = {
      certificates = work.value.certificates;
    };
    _.email.work.enable = true;
  }
)
