let
  razorback = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgmOVCcqq/Kc4AkGozUtNLXFGO9ntx9NCP3wmUUAsJq root@razorback";
  tachi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEucViDTf48b09h0bWJWgaQuqs75g2kMQHnTaF7Qs4sq root@tachi";
  systems = [
    razorback
    tachi
  ];
  yubikey = {
    recipient = "age1yubikey1q2ljnfjleslpp9gjhch736m2xqm66ly4lgs9he5ap8ckmn62d3ttw4skjat";
    identity = .age/age-yubikey-identity-1dfcab53.txt;
  };
  yubikey_nano = {
    recipient = "age1yubikey1qv9z53sdsjl83n9tpcrhgsx0rgh4n3pf9sxssk549m8dthw2fenuu892ekk";
    identity = .age/age-yubikey-identity-1fc27592.txt;
  };
in
{
  "work/client.pfx.age".publicKeys = [ tachi ];
  "work/client.pem.age".publicKeys = [ tachi ];
}
