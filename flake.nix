{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    astal,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = {
      default = self.packages.${system}.cassiopea;
      cassiopea = pkgs.callPackage ./nix/package.nix {
        inherit
          self
          astal
          system
          pkgs
          ;
      };
    };

    homeManagerModules = {
      default = self.homeManagerModules.cassiopea;
      cassiopea = import ./nix/hm-module.nix self;
    };
  };
}
