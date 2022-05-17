{
  description = "Hyprland is a dynamic tiling Wayland compositor that doesn't sacrifice on its looks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    wlroots = {
      url = "gitlab:wlroots/wlroots?host=gitlab.freedesktop.org";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    genSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgsFor = nixpkgs.legacyPackages;
  in {
    packages = genSystems (system: {
      wlroots = pkgsFor.${system}.wlroots.overrideAttrs (prev: {
        src = inputs.wlroots;
      });
      default = pkgsFor.${system}.callPackage ./default.nix {
        version = self.lastModifiedDate;
        inherit (self.packages.${system}) wlroots;
      };
    });
  };
}
