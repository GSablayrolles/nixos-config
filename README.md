<h1 align="center">
   <img src="https://github.com/user-attachments/assets/270f70c1-2579-473e-91db-07afd36e8e1c" width="100px" /> 
   <br>
      My NixOS Flake Config
   <br>
      <img src="https://github.com/user-attachments/assets/25d2f8a3-ef44-40e4-9cfb-d4092cec1b38" width="600px" /> <br>

   <div align="center">
      <p></p>
      <div align="center">
         <a href="https://github.com/GSablayrolles/nixos-config/stargazers">
            <img src="https://img.shields.io/github/stars/GSablayrolles/nixos-config?color=FABD2F&labelColor=282828&style=for-the-badge&logo=starship&logoColor=FABD2F">
         </a>
         <a href="https://github.com/GSablayrolles/nixos-config/">
            <img src="https://img.shields.io/github/repo-size/GSablayrolles/nixos-config?color=B16286&labelColor=282828&style=for-the-badge&logo=github&logoColor=B16286">
         </a>
         <a = href="https://nixos.org">
            <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=282828&logo=NixOS&logoColor=458588&color=458588">
         </a>
         <a href="https://github.com/GSablayrolles/nixos-config/blob/main/LICENSE">
            <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=282828&colorB=98971A&logo=unlicense&logoColor=98971A&"/>
         </a>
      </div>
      <br>
   </div>
</h1>

## Screeshots
### Hyprland / Wayland window configuration
![Wayland window configuration](https://github.com/user-attachments/assets/660ac312-3551-4d2a-a853-c0d2b2a23957)

### Rofi and Swaync 
![Rofi and Swaync](https://github.com/user-attachments/assets/7ffccfd9-ac27-43c4-9533-f5297386bfd0)

## Layout
```rust
 nixos-config
├──  flake.lock
├──  flake.nix
├── 󱂵 home
│   └──  guillaume
│       ├──  atlantis.nix
│       ├──  curiosity.nix
│       ├──  features
│       ├──  iss.nix
│       └──  shared
├──  hosts
│   ├──  atlantis
│   │   ├──  default.nix
│   │   ├──  hardware-configuration.nix
│   │   ├──  network.nix
│   │   └──  sops.nix
│   ├──  curiosity
│   │   ├──  default.nix
│   │   ├──  hardware-configuration.nix
│   │   ├──  network.nix
│   │   └──  sops.nix
│   ├──  iss
│   │   ├──  default.nix
│   │   ├──  hardware-configuration.nix
│   │   ├──  homelab.nix
│   │   ├──  network.nix
│   │   └──  sops.nix
│   └──  shared
│       ├──  content
│       ├──  global
│       ├──  homelab
│       ├──  secrets.yaml
│       └──  users
└── 󰂺 README.md
```

- [flake.nix](flake.nix) Flake for my configuration
- [home/guillaume](home/guillaume) HomeManager modularized configuration
  - [features](home/guillaume/features) Features configuration to enable within device
  - [shared](home/guillaume/shared) Shared modules configuration 
  - [atlantis.nix](home/guillaume/atlantis.nix) Desktop module configuration
  - [curiosity.nix](home/guillaume/curiosity.nix) Laptop module configuration
  - [iss.nix](home/guillaume/iss.nix) Server module configuration
- [hosts](hosts) Per-host configurations that contain machine specific configurations
  - [atlantis] Desktop specific configuration 
  - [curiosity] Laptop specific configuration
  - [iss] Server specific configuration
 
## Theming
Style is handled by [Stylix](https://github.com/danth/stylix) and I am using the `gruvbox-dark-medium` theme

## ⌨️ Keybinds

Keybindings are defined in [`window-bind.nix`](./home/guillaume/features/desktop/hyprland/window-bind.nix). 

Here are some of the main keybinds:

| Category | Key Examples | Purpose |
|----------|--------------|---------|
| **Navigation** | `SUPER + 0-9/arrow keys` | workspace & window navigation |
| **Applications** | `SUPER + t/x/w` | terminal, launcher, notifications center |
| **Window Control** | `SUPERSHIFT + q/f/space` | close, fullscreen, float windows |
| **Media & Tools** | `Print` | screenshots |
