{
  description = "Claude Code CLI tool by Anthropic";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      getNixpkgs = system: nixpkgs.legacyPackages.${system};
      getModule = system: import ./default.nix { pkgs = getNixpkgs system; };
    in
    {
      packages = forAllSystems (system: (getModule system).packages);

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/claude-code";
        };
        claude-code = {
          type = "app";
          program = "${self.packages.${system}.claude-code}/bin/claude-code";
        };
      });

      devShells = forAllSystems (system: {
        default = (getModule system).devShell;
      });
    };
}
