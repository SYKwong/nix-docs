{
  description = "Unified Astro Starlight documentation hub for nix-config and flake-templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      treefmtEval = forAllSystems (
        system:
        treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
          projectRootFile = "flake.nix";

          programs = {
            deadnix.enable = true;
            nixfmt.enable = true;
            prettier.enable = true;
            shellcheck = {
              enable = true;
              excludes = [ ".envrc" ];
            };
            shfmt.enable = true;
            statix.enable = true;
          };

          settings = {
            global.excludes = [
              "package-lock.json"
              "src/content/docs/nix-config/**"
              "src/content/docs/templates/**"
            ];
            formatter.shfmt.options = [
              "-i"
              "2"
              "-ci"
              "-s"
            ];
          };
        }
      );
    in
    {
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    };
}
