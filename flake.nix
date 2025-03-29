{
  description = "Claude Code CLI tool by Anthropic";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      version = "0.2.56";
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: rec {
        inherit ((import ./default.nix { inherit pkgs version; })) claude-code;
        default = claude-code;
      });

      apps = forAllSystems ({ pkgs }: rec {
        claude-code = {
          type = "app";
          program = "${self.packages.${pkgs.system}.claude-code}/bin/claude";
        };
        default = claude-code;
      });

      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
            just
            nixpkgs-fmt
            statix
          ];
        };
      });

      checks = forAllSystems ({ pkgs }:
        import ./tests.nix { inherit pkgs version; }
      );
    };
}
