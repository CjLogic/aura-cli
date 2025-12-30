{
  description = "CLI for Aura dots";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    aura-shell = {
      url = "github:CjLogic/aura-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.aura-cli.follows = "";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    forAllSystems = fn:
      nixpkgs.lib.genAttrs nixpkgs.lib.platforms.linux (
        system: fn nixpkgs.legacyPackages.${system}
      );
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: rec {
      aura-cli = pkgs.callPackage ./default.nix {
        rev = self.rev or self.dirtyRev;
        aura-shell = inputs.aura-shell.packages.${pkgs.system}.default;
      };
      with-shell = aura-cli.override {withShell = true;};
      default = aura-cli;
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = [self.packages.${pkgs.system}.with-shell];
      };
    });
  };
}
