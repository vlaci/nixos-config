# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  catpuccin-bat = {
    pname = "catpuccin-bat";
    version = "d714cc1d358ea51bfc02550dabab693f70cccea0";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
      fetchSubmodules = false;
      sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
    };
    date = "2024-04-25";
  };
  flameshot = {
    pname = "flameshot";
    version = "5f30631a415a7202b474fddc68de5b3904cd5d87";
    src = fetchFromGitHub {
      owner = "flameshot-org";
      repo = "flameshot";
      rev = "5f30631a415a7202b474fddc68de5b3904cd5d87";
      fetchSubmodules = false;
      sha256 = "sha256-tt9Q8HWNIXwmwjY6/8SpJSOCIKJ+P56BYpANykGxfYM=";
    };
    date = "2024-05-06";
  };
  hexdiff = {
    pname = "hexdiff";
    version = "3e96f27e65167c619ede35ab04232163dc273e69";
    src = fetchFromGitHub {
      owner = "ahroach";
      repo = "hexdiff";
      rev = "3e96f27e65167c619ede35ab04232163dc273e69";
      fetchSubmodules = false;
      sha256 = "sha256-G6Qi7e4o+0ahcslJ8UfJrdoc8NNkY+nl6kyDlkJCo9I=";
    };
    date = "2018-01-24";
  };
  mujmap = {
    pname = "mujmap";
    version = "5f700af890769185ad99d4aae9f53496bb2aa6f2";
    src = fetchFromGitHub {
      owner = "elizagamedev";
      repo = "mujmap";
      rev = "5f700af890769185ad99d4aae9f53496bb2aa6f2";
      fetchSubmodules = false;
      sha256 = "sha256-mSJ6uyZSaWWdhqiYNcIm7lC6PZZrZ8PSdxfu+s9MZD0=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./mujmap-5f700af890769185ad99d4aae9f53496bb2aa6f2/Cargo.lock;
      outputHashes = {
        
      };
    };
    date = "2023-05-15";
  };
  nu-scripts = {
    pname = "nu-scripts";
    version = "f1b0432ad96637ae24848f3750af9b6544b9ee9c";
    src = fetchFromGitHub {
      owner = "nushell";
      repo = "nu_scripts";
      rev = "f1b0432ad96637ae24848f3750af9b6544b9ee9c";
      fetchSubmodules = false;
      sha256 = "sha256-hH0EC6ZqtDBMWkupm2kD6cGQoNjsfPZFyaUOTyhpc3g=";
    };
    date = "2024-05-10";
  };
  swaylock = {
    pname = "swaylock";
    version = "f9ce3f193bc2f035790372b550547686075f4923";
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "swaylock";
      rev = "f9ce3f193bc2f035790372b550547686075f4923";
      fetchSubmodules = false;
      sha256 = "sha256-YlfOR1KpeddJxk6kKOzk/DTxsRETPRHXvBqZf/5XZ54=";
    };
    date = "2024-03-05";
  };
  wezterm-nightly = {
    pname = "wezterm-nightly";
    version = "ca27f921e2f5b25fa1a1b4395f972676d685b62c";
    src = fetchFromGitHub {
      owner = "wez";
      repo = "wezterm";
      rev = "ca27f921e2f5b25fa1a1b4395f972676d685b62c";
      fetchSubmodules = true;
      sha256 = "sha256-J4L5+qtXsd8GMUS9SBSKl0HCQvxI1txUdGNfgeJCIno=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./wezterm-nightly-ca27f921e2f5b25fa1a1b4395f972676d685b62c/Cargo.lock;
      outputHashes = {
        "xcb-imdkit-0.3.0" = "sha256-fTpJ6uNhjmCWv7dZqVgYuS2Uic36XNYTbqlaly5QBjI=";
        "sqlite-cache-0.1.3" = "sha256-sBAC8MsQZgH+dcWpoxzq9iw5078vwzCijgyQnMOWIkk=";
      };
    };
    date = "2024-05-10";
  };
  zsh-alias-tips = {
    pname = "zsh-alias-tips";
    version = "41cb143ccc3b8cc444bf20257276cb43275f65c4";
    src = fetchFromGitHub {
      owner = "djui";
      repo = "alias-tips";
      rev = "41cb143ccc3b8cc444bf20257276cb43275f65c4";
      fetchSubmodules = false;
      sha256 = "sha256-ZFWrwcwwwSYP5d8k7Lr/hL3WKAZmgn51Q9hYL3bq9vE=";
    };
    date = "2023-01-19";
  };
  zsh-calc = {
    pname = "zsh-calc";
    version = "5b4c85977b693c15eb052cde6b5cef0d6610f567";
    src = fetchFromGitHub {
      owner = "arzzen";
      repo = "calc.plugin.zsh";
      rev = "5b4c85977b693c15eb052cde6b5cef0d6610f567";
      fetchSubmodules = false;
      sha256 = "sha256-N4FBN7iyyiEyZX/opj63D5acA1Oh0YpFXdz83oIOWPE=";
    };
    date = "2021-03-24";
  };
  zsh-fast-syntax-highlighting = {
    pname = "zsh-fast-syntax-highlighting";
    version = "v1.55";
    src = fetchFromGitHub {
      owner = "zdharma-continuum";
      repo = "fast-syntax-highlighting";
      rev = "v1.55";
      fetchSubmodules = false;
      sha256 = "sha256-DWVFBoICroKaKgByLmDEo4O+xo6eA8YO792g8t8R7kA=";
    };
  };
  zsh-git-prompt-useremail = {
    pname = "zsh-git-prompt-useremail";
    version = "902541b73a23061e6cbeb889e0a7f179a87d047e";
    src = fetchFromGitHub {
      owner = "mroth";
      repo = "git-prompt-useremail";
      rev = "902541b73a23061e6cbeb889e0a7f179a87d047e";
      fetchSubmodules = false;
      sha256 = "sha256-lTyqIs2OqnWVVG/yMC9KYvI2bLL77SuIX9NsmWUepNg=";
    };
    date = "2017-04-12";
  };
}
