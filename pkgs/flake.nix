{
  inputs = {
    hexdiff = {
      url = "github:ahroach/hexdiff";
      flake = false;
    };

    zsh-alias-tips = {
      url = "github:djui/alias-tips";
      flake = false;
    };

    zsh-calc = {
      url = "github:arzzen/calc.plugin.zsh";
      flake = false;
    };

    zsh-git-prompt-useremail = {
      url = "github:mroth/git-prompt-useremail";
      flake = false;
    };

    zsh-fast-syntax-highlighting = {
      url = "github:zdharma/fast-syntax-highlighting";
      flake = false;
    };

    picom = {
      url = "github:yshui/picom";
      flake = false;
    };

    awesome-awpwkb = {
      url = "github:vladimir-g/awpwkb/42ce6e5fc89b5333cd45e7c06cf32f8ef35c03a5";
      flake = false;
    };

    awesome-lain = {
      url = "github:lcpz/lain/e0bffc00566fbc0c05dc01700c569a589a6900eb";
      flake = false;
    };

    awesome-sharedtags = {
      url = "github:Drauthius/awesome-sharedtags/32d878d0d12bcfd900f2c6a7516a1370e6ebb7d6";
      flake = false;
    };

    nix-plugins = {
      url = "github:shlevy/nix-plugins";
      flake = false;
    };

    age-plugin-yubikey = {
      url = "github:str4d/age-plugin-yubikey";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }: {
    overlay = final: prev: { pkgsrcs = self.package; };
    package =
      let
        inherit (nixpkgs) lib;

        mkVersion = name: input:
          let
            inputs = (builtins.fromJSON
              (builtins.readFile ./flake.lock)).nodes;

            ref =
              if lib.hasAttrByPath [ name "original" "ref" ] inputs
              then inputs.${name}.original.ref
              else "";

            version =
              let version' = builtins.match
                "[[:alpha:]]*[-._]?([0-9]+(\.[0-9]+)*)+"
                ref;
              in
              if lib.isList version'
              then lib.head version'
              else if input ? lastModifiedDate && input ? shortRev
              then "${lib.substring 0 8 input.lastModifiedDate}_${input.shortRev}"
              else null;
          in
          version;
      in
      lib.mapAttrs
        (pname: input:
          let
            version = mkVersion pname input;
          in
          input // { inherit pname; }
          // lib.optionalAttrs (! isNull version)
            {
              inherit version;
            }
        )
        (lib.filterAttrs (n: _: n != "nixpkgs")
          self.inputs);
  };
}
