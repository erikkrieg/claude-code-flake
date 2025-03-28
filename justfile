# Justfile for claude-code-flake

# Set environment variables for all commands
set export := true
NIXPKGS_ALLOW_UNFREE := "1"

# List available commands
default:
    @just --list

# Build the package
build:
    nix build --impure

# Run tests
test:
    nix flake check --impure

# Enter a development shell
dev:
    nix develop --impure

# Show information about the flake
info:
    nix flake show