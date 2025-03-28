# Claude Code Flake

A Nix flake for the [Claude Code CLI](https://docs.anthropic.com/claude/docs/claude-code) by Anthropic.

## Usage

### Install using nix profile

```bash
nix profile install github:username/claude-code-flake
```

### Run directly

```bash
nix run github:username/claude-code-flake
```

### Use in another flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    claude-code-flake.url = "github:username/claude-code-flake";
  };

  outputs = { self, nixpkgs, claude-code-flake }:
    let
      system = "x86_64-linux";  # or your system
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Use the package
      packages.${system}.default = claude-code-flake.packages.${system}.claude-code;
      
      # Or in an environment
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          claude-code-flake.packages.${system}.claude-code
        ];
      };
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