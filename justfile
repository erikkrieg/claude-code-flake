set export := true
NIXPKGS_ALLOW_UNFREE := "1"

# List available commands
default:
    @just --list

# Build the package
build *ARGS:
    nix build --impure {{ARGS}}

# Run tests
test *ARGS:
    nix flake check --impure {{ARGS}}

# Enter a development shell
dev *ARGS:
    nix develop --impure {{ARGS}}

alias show := info
# Show information about the flake
info:
    nix flake show

# Run a command from the package
run *ARGS:
    nix run --impure {{ARGS}}

# Lint Nix files
lint:
    nixpkgs-fmt --check *.nix
    statix check .
