# Nix Config

## Switch Commands
Build for laptop
```bash
sudo nixos-rebuild switch --flake ./#nixos-laptop
```

Build for desktop
```bash
sudo nixos-rebuild switch --flake ./#nixos-desktop
```

Build for hyperv_vm
```bash
sudo nixos-rebuild switch --flake ./#nixos-hyperv-vm
```

Build for KVM vm image
```bash
nix build .#nixosConfigurations.qcow-image.config.system.build.diskoImagesScript
```

## Initial Install command for new machines
```bash
sudo ./install.sh
```

## Deploy Home Directory only
```bash
home-manager switch --flake ./
```

## Initial Install command for new machines
```bash
nix run .#resume --impure
```

