{
  disks ? [ "/dev/nvme0n1" ],
  ...
}:
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt-root";
                extraOpenArgs = [ "--allow-discards" ];
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = "48G";
            content = {
              type = "swap";
            };
          };
          rpool = {
            size = "900G";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
        };
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        postCreateHook = "zfs snapshot rpool/tachi/root@blank && zfs snapshot -r rpool/tachi/home@blank";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          normalization = "formD";
          mountpoint = "none";
          relatime = "on";
          xattr = "sa";
        };
        datasets = {
          "tachi" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
            options.compression = "zstd";
          };
          "tachi/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            options.compression = "zstd";
          };
          "tachi/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
            options.compression = "zstd";
          };
          "tachi/home" = {
            type = "zfs_fs";
            options.canmount = "off";
            options.mountpoint = "legacy";
          };
          "tachi/home/vlaci" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist/home/vlaci";
          };
          "tachi/var" = {
            type = "zfs_fs";
            options.canmount = "off";
            options.mountpoint = "legacy";
          };
          "tachi/var/lib" = {
            type = "zfs_fs";
            options.canmount = "off";
            options.mountpoint = "legacy";
          };
          "tachi/var/lib/libvirt" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist/var/lib/libvirt";
          };
          #          "tachi/containerd" = {
          #            type = "zfs_fs";
          #            mountpoint = "/var/lib/containerd/io.containerd.snapshotter.v1.zfs";
          #          };
        };
      };
    };
  };
}
