# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      # <home-manager/nixos>
    ];

  # Bootloader.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.extraHosts =
    ''
      127.0.0.1 whatever
      127.0.0.2 whatever

      127.0.0.1 pg-loadbalancetest
      127.0.0.2 pg-loadbalancetest
      127.0.0.3 pg-loadbalancetest

      192.168.50.98 nixos-desktop	
      172.18.0.1 nixos-laptop 
    '';
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
      gnome.enable = true;
    };

    displayManager = {
      defaultSession = "gnome";
      gdm.enable = true;
      startx.enable = true;
      # lightdm = {
      #   enable = true;
      #   greeter.enable = true;
      # };
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };
  services.logind.extraConfig = ''
    RuntimeDirectorySize=8G
  '';
  services.xrdp = {
    enable = true;
    defaultWindowManager = "i3";
    openFirewall = true;
  };
  services.picom.enable = true;
  services.sysstat = {
    enable = true;
    collect-frequency = "*:00/1";
  };
  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew";
    hashedPassword = "$y$j9T$qD5idLei07VLmuqTUaEMA1$vka3cUOh1T8CI05G5xoUMUZ5iZUmqoXxDKqY4m0JfVC";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      qemu
    ];
  };
  users.users.fei = {
    isNormalUser = true;
    description = "Mommy Bear";
    extraGroups = [ "networkmanager" ];
  };
  users.users.bunbun = {
    isNormalUser = true;
    description = "Baby Bun";
    extraGroups = [ "networkmanager" ];
  };
  users.users.babybear = {
    isNormalUser = true;
    description = "Bun Bear";
    extraGroups = [ "networkmanager" ];
  };

  nixpkgs.config.allowUnfree = true;

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
  virtualisation = {
    vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 8048;
        cores = 4;
        graphics = true;
      };
    };
    docker.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
        swtpm.enable = true;
      };
    };
  };

  environment.sessionVariables = rec {
    TERMINAL = "alacritty";
    EDITOR = "nvim";
  };

  fonts.packages = with pkgs; [
    nerdfonts
    font-awesome
  ];
  environment.systemPackages = with pkgs; [
    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ nerdtree gruvbox ];
        opt = [ ];
      };
      vimrcConfig.customRC = ''
        " your custom vimrc
        set nocompatible
        set backspace=indent,eol,start
        " Turn on syntax highlighting by default
        syntax on
        " ...
      '';
    }
    )
    rustc
    nodejs
    home-manager
    virt-viewer
    nfs-utils
    bubblewrap
    pavucontrol
    man-pages 
    man-pages-posix
  ];
  documentation.dev.enable = true;

  programs = {
    thunar.enable = true;
    virt-manager.enable = true;
    steam.enable = true;
  };


}
