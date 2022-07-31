{ linuxPackagesFor, linuxPackages  }:

linuxPackages.extend (self: super: {
  kernel = super.kernel.override (orig: {
    kernelPatches = (super.kernelPatches or []) ++ [
      {
        name = "add-acs-overrides";
        patch = ./add-acs-overrides_5_x.patch;
      }
    ];
  });
})
