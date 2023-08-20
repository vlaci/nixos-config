{ mkYarnPackage }:

mkYarnPackage {
  name = "qutebrowser-js-env";
  src = ./.;
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;
}
