{
  description = "My Awesome Desktop Shell – Cassiopea";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ags,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    astalPackages = with ags.packages.${system}; [
      astal4
      powerprofiles
      battery
      mpris
      wireplumber
      network
      tray
      io
      apps
      bluetooth
      notifd
    ];

    extraPackages =
      astalPackages
      ++ [
        pkgs.lsof
        pkgs.wl-gammarelay-rs
        pkgs.upower
        pkgs.networkmanager
      ];
  in {
    packages.${system} = {
      default = self.packages.${system}.cassiopea;
      cassiopea = import ./nix/package.nix {inherit pkgs ags system extraPackages;};
    };

    devShells.${system}.default =
      import ./nix/devshell.nix {inherit pkgs ags system extraPackages;};

    homeManagerModules = {
      default = self.homeManagerModules.cassiopea;
      cassiopea = import ./nix/hm-module.nix self;
    };
  };
}
