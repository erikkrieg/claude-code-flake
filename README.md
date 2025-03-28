# Claude Code Flake

A Nix flake for the [Claude Code CLI](https://docs.anthropic.com/claude/docs/claude-code) by Anthropic.

> **Note:** You'll need an Anthropic API key set up as described in the [Claude Code documentation](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview).

## Usage

### Install using nix profile

```bash
nix profile install github:erikkrieg/claude-code-flake
```

### Run directly

```bash
nix run github:erikkrieg/claude-code-flake
```

### Use in another flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    claude-code-flake.url = "github:erikkrieg/claude-code-flake";
  };

  outputs = { self, nixpkgs, claude-code-flake }:
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
    in {
      # Use the package
      packages = forAllSystems ({ pkgs }: {
        default = claude-code-flake.packages.${pkgs.system}.claude-code;
      });
      
      # Or in an environment
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = [
            claude-code-flake.packages.${pkgs.system}.claude-code
          ];
        };
      });
    };
}
```

## Development

This flake includes a development shell with necessary tools:

```bash
nix develop
```

### Build commands

This project uses [just](https://github.com/casey/just) as a command runner. Available commands:

```bash
# List available commands
just

# Build the package
just build

# Enter development shell
just dev
```

## License

Claude Code is proprietary software by Anthropic.