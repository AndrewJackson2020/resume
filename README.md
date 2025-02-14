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

Build for VM
```bash
sudo nixos-rebuild switch --flake ./#nixos-hyperv-vm
```

## Initial Install command for new machines
```bash
sudo ./install.sh
```

## Initial Install command for new machines
```bash
nix run .#resume --impure
```
