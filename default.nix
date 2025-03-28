{ pkgs, version ? "latest" }: {
  claude-code = pkgs.stdenv.mkDerivation {
    pname = "claude-code";
    inherit version;
    src = null;
    unpackPhase = "true";
    nativeBuildInputs = [ pkgs.nodejs ];
    buildInputs = [ pkgs.cacert ];

    buildPhase = ''
      mkdir -p build
      cat > build/package.json <<EOF
      {
        "name": "claude-code-wrapper",
        "version": "1.0.0",
        "description": "Wrapper for Claude Code CLI",
        "dependencies": {
          "@anthropic-ai/claude-code": "${version}"
        }
      }
      EOF
    '';

    installPhase = ''
      export HOME=$PWD
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      export NODE_TLS_REJECT_UNAUTHORIZED=0
      mkdir -p $out/bin $out/lib
      cp -r build/* $out/lib/
      cd $out/lib
      echo "Installing package..."
      npm install --no-fund
      cat > $out/bin/claude <<EOF
      #!/bin/sh
      export NODE_PATH=$out/lib/node_modules
      
      # Add special flags for testing
      if [ "\$1" = "--print-node-path" ]; then
        echo \$NODE_PATH
        exit 0
      fi
      
      if [ "\$1" = "--node-version" ]; then
        exec ${pkgs.nodejs}/bin/node --version
        exit 0
      fi
      
      exec ${pkgs.nodejs}/bin/node $out/lib/node_modules/@anthropic-ai/claude-code/cli.js "\$@"
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