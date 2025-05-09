# Do not modify this file!  It was generated by ‘nixos-generate-config’ and may be overwritten by future invocations.  Please make changes to 
# /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{ imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ]; boot.initrd.kernelModules = [ ]; 
  boot.kernelModules = [ "kvm-intel" ]; boot.extraModulePackages = [ ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.timeout = null;

  fileSystems."/" = { device = "rpool/root";
      fsType = "zfs";
    };

  fileSystems."/home" = { device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" = { device = "/dev/disk/by-uuid/D2FC-FE6B";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking (the default) this is the recommended approach. When using 
  # systemd-networkd it's still possible to use this option, but it's recommended to use it in conjunction with explicit per-interface declarations 
  # with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.hostId = "abcd1234";
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true; networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux"; powerManagement.cpuFreqGovernor = lib.mkDefault "powersave"; hardware.cpu.intel.updateMicrocode 
  = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

