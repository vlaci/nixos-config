{ nix }:

nix.overrideAttrs (super: {
  name = "${super.pname}-patched-${super.version}";
  patches = (super.patches or [ ]) ++ [
    ./0001-fetchers-always-use-git-work-dir-state-for-local-rep.patch
  ];
})
