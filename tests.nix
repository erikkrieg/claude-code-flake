{ pkgs, version ? "latest" }:
let
  claudeCode = (import ./default.nix { inherit pkgs; }).claude-code;

  makeTest = name: script: pkgs.runCommand name { } ''
    echo "Running test: ${name}"
    ${script}
    echo "✅ Test passed: ${name}" > $out
  '';

  smokeTest = makeTest "claude-code-smoke-test" ''
    if [ ! -x ${claudeCode}/bin/claude ]; then
      echo "ERROR: claude binary not found or not executable"
      exit 1
    fi
  '';

  versionTest = makeTest "claude-code-version-test" ''
    if ! ${claudeCode}/bin/claude --version 2>&1 | grep -q "${version}"; then
      echo "ERROR: Version mismatch or command failed"
      echo "Expected: ${version}"
      echo "Actual: $(${claudeCode}/bin/claude --version 2>&1)"
      exit 1
    fi
  '';

  helpTest = makeTest "claude-code-help-test" ''
    # Run help command and check in one step
    if ! ${claudeCode}/bin/claude --help 2>&1 | grep -q "Usage: claude"; then
      echo "ERROR: Help command failed or missing expected text"
      echo "Expected to find: 'Usage: claude'"
      echo "Actual output: $(${claudeCode}/bin/claude --help 2>&1)"
      exit 1
    fi
  '';
in
{
  inherit smokeTest versionTest helpTest;
}
