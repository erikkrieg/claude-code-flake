{ pkgs }:
let
  nodejs = pkgs.nodejs_18;
in
{
  packages = rec {
    claude-code = pkgs.buildNpmPackage {
      pname = "claude-code";
      version = "latest";
      src = ./.;
      npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      dontNpmBuild = true;
      buildInputs = [ nodejs ];
      npmFlags = [ "--global" ];
      installPhase = ''
        mkdir -p $out/bin
        ${nodejs}/bin/npm install --global @anthropic-ai/claude-code
        ln -s ${nodejs}/lib/node_modules/@anthropic-ai/claude-code/bin/claude $out/bin/claude
      '';
      meta = with pkgs.lib; {
        description = "Claude Code CLI tool by Anthropic";
        homepage = "https://www.anthropic.com/";
        license = licenses.unfree;
        platforms = platforms.all;
      };
    };
    default = claude-code;
  };

  devShell = pkgs.mkShell {
    packages = [
      nodejs
    ];
  };
}
