{ pkgs, version ? "latest" }: {
  claude-code = pkgs.buildNpmPackage {
    pname = "claude-code";
    inherit version;
    src = ./.;
    npmDepsHash = "sha256-eLlupD2G3rXk9nM6knrrKq0nLxeJiZX6AWogEB1pTWk=";
    dontNpmBuild = true;

    postPatch = ''
      # Update package.json to use the specified version
      substituteInPlace package.json \
        --replace '"@anthropic-ai/claude-code": "latest"' '"@anthropic-ai/claude-code": "${version}"'
    '';

    installPhase = ''
      mkdir -p $out/bin $out/lib
      cp -r node_modules/* $out/lib/
      cat > $out/bin/claude <<EOF
      #!/bin/sh
      export NODE_PATH=$out/lib
      if [ "\$1" = "--print-node-path" ]; then
        echo \$NODE_PATH
        exit 0
      fi
      if [ "\$1" = "--node-version" ]; then
        exec ${pkgs.nodejs}/bin/node --version
        exit 0
      fi
      exec ${pkgs.nodejs}/bin/node $out/lib/@anthropic-ai/claude-code/cli.js "\$@"
      EOF
      chmod +x $out/bin/claude
    '';

    meta = with pkgs.lib; {
      description = "Claude Code is an agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster by executing routine tasks, explaining complex code, and handling git workflows - all through natural language commands.";
      homepage = "https://docs.anthropic.com/s/claude-code";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  };
}
