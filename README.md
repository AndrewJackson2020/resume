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

Run VM
```bash
nixos-rebuild build-vm --flake .#qvm_vm
./result/bin/run-nixos-vm
```

## Initial Install command for new machines
```bash
sudo ./install.sh
```

## Deploy Home Directory only
```bash
home-manager switch --flake ./
```

## Build resume
```bash
nix run .#resume --impure -- compile ./resume/andrew_resume.typ
```

## Format nix files
```bash
nix fmt
```

