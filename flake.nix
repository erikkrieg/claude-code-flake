{
  description = "Claude Code CLI tool by Anthropic";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
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
      packages = forAllSystems ({ pkgs }: {
        claude-code = (import ./default.nix { inherit pkgs; }).claude-code;
        default = (import ./default.nix { inherit pkgs; }).claude-code;
      });
      
      apps = forAllSystems ({ pkgs }: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.system}.default}/bin/claude";
        };
        claude-code = {
          type = "app";
          program = "${self.packages.${pkgs.system}.claude-code}/bin/claude";
        };
      });
      
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
            just
          ];
        };
      });
      
      checks = forAllSystems ({ pkgs }: 
        let
          tests = import ./tests.nix { inherit pkgs; };
        in
        {
          inherit (tests) smokeTest versionTest helpTest nodeTest;
        }
      );
    };
}