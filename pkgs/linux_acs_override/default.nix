{ linuxPackagesFor, linuxPackages }:

linuxPackages.extend (
  self: super: {
    kernel = super.kernel.override (orig: {
      kernelPatches = (super.kernelPatches or [ ]) ++ [
        {
          name = "add-acs-overrides";
          patch = ./0001-add-acs-overrides.patch;
        }
        {
          name = "i915-vga-arbiter";
          patch = ./0002-i915-vga-arbiter.patch;
        }
      ];
    });
  }
)
