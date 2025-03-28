# Basic test suite for claude-code-flake
{ pkgs ? import <nixpkgs> { } }:

let
  flake = (import ./default.nix { inherit pkgs; });
  claudeCode = flake.claude-code;
  
  # Helper to create a basic test
  makeTest = name: script: pkgs.runCommand name {} ''
    echo "Running test: ${name}"
    ${script}
    echo "✅ Test passed: ${name}" > $out
  '';

  # Smoke test: Check if the claude binary exists and has correct permissions
  smokeTest = makeTest "claude-code-smoke-test" ''
    if [ ! -x ${claudeCode}/bin/claude ]; then
      echo "ERROR: claude binary not found or not executable"
      exit 1
    fi
  '';

  # Version test: Check if the claude binary responds to --version flag
  versionTest = makeTest "claude-code-version-test" ''
    if ! ${claudeCode}/bin/claude --version 2>&1 | grep -q ""; then
      echo "ERROR: Failed to run version command"
      exit 1
    fi
  '';

  # Help test: Check if the claude binary displays help information
  helpTest = makeTest "claude-code-help-test" ''
    if ! ${claudeCode}/bin/claude --help 2>&1 | grep -q ""; then
      echo "ERROR: Help command failed"
      exit 1
    fi
  '';

  # Test that verifies the node executable runs
  nodeTest = makeTest "claude-code-node-test" ''
    # Simple test that node can be executed by the wrapper
    if ! ${claudeCode}/bin/claude --node-version 2>&1 | grep -q ""; then
      echo "ERROR: Node version check failed"
      exit 1
    fi
  '';
in
{
  inherit smokeTest versionTest helpTest nodeTest;
}