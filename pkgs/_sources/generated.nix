# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  catpuccin-bat = {
    pname = "catpuccin-bat";
    version = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
      fetchSubmodules = false;
      sha256 = "sha256-s0CHTihXlBMCKmbBBb8dUhfgOOQu9PBCQ+uviy7o47w=";
    };
    date = "2024-08-05";
  };
  flameshot = {
    pname = "flameshot";
    version = "fd3772e2abb0b852573fcaa549ba13517f13555c";
    src = fetchFromGitHub {
      owner = "flameshot-org";
      repo = "flameshot";
      rev = "fd3772e2abb0b852573fcaa549ba13517f13555c";
      fetchSubmodules = false;
      sha256 = "sha256-WXUxrirlevqJ+dnXZbN1C1l5ibuSI/DBi5fqPx9nOGQ=";
    };
    date = "2024-08-02";
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
    version = "614b0733104a7753ed7d775224fe5918877b71de";
    src = fetchFromGitHub {
      owner = "nushell";
      repo = "nu_scripts";
      rev = "614b0733104a7753ed7d775224fe5918877b71de";
      fetchSubmodules = false;
      sha256 = "sha256-EmlwDTEby2PAOQBUAhjiBJ8ymVW3H23V78dFaF8DQKw=";
    };
    date = "2024-08-30";
  };
  swaylock = {
    pname = "swaylock";
    version = "de0731de6a44d99532fcd46c5894cff5f10e65a6";
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "swaylock";
      rev = "de0731de6a44d99532fcd46c5894cff5f10e65a6";
      fetchSubmodules = false;
      sha256 = "sha256-1+AXxw1gH0SKAxUa0JIhSzMbSmsfmBPCBY5IKaYtldg=";
    };
    date = "2024-08-23";
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
