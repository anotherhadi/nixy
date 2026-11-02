# Kimi Code: Moonshot's agentic coding CLI
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.kimi-code = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        package = pkgs.stdenv.mkDerivation rec {
          pname = "kimi-code";
          version = "2.4.1";
          src = pkgs.fetchurl {
            url = "https://code.kimi.ai/kimi-code/binaries/${version}/kimi-code-linux-x64.tar.gz";
            hash = "sha256-9KIl+4r+A5QVHnIbw82U1x4xT76n91kARTVW2n2HON4=";
          };
          sourceRoot = ".";
          nativeBuildInputs = [pkgs.autoPatchelfHook];
          buildInputs = [pkgs.stdenv.cc.cc.lib];
          dontStrip = true; # Would drop the embedded JS blob
          installPhase = ''
            install -Dm755 kimi $out/bin/kimi
          '';
          meta.mainProgram = "kimi";
        };

        # Sandboxed: network, but only sees the project it is started in and its own state.
        # Secrets (~/.ssh, gh...) are hidden, so no push nor signed commits from inside.
        sandboxed = (mkSandbox pkgs).wrap {
          inherit package;
          config = {sloth, ...}: let
            home = sloth.concat' sloth.homeDir;
          in {
            bubblewrap = {
              network = true;
              bind.rw = [
                (sloth.env "KIMI_SANDBOX_DIR") # Set by the wrapper below
                (home "/.kimi-code") # Config, credentials, sessions
                (home "/.cache/go-build")
                (home "/.local/share/go") # GOPATH (module cache)
              ];
              bind.ro = [
                (home "/.config/git")
                "/bin" # /bin/sh, hardcoded by kimi's shell tool
                "/usr/bin" # /usr/bin/env shebangs
                "/nix/var/nix/daemon-socket" # nix build/eval through the daemon (user isn't trusted)
              ];
              tmpfs = ["/tmp"];
              env = {
                TMPDIR = "/tmp";
                NIX_REMOTE = "daemon";
                KIMI_CODE_NO_AUTO_UPDATE = "1"; # Managed by Nix
                KIMI_DISABLE_TELEMETRY = "1";
              };
            };
          };
        };

        kimi = pkgs.writeShellScriptBin "kimi" ''
          mkdir -p "$HOME/.kimi-code"

          # Project = enclosing git repo (so .git is visible from a subdir), else the current dir
          KIMI_SANDBOX_DIR=$(${pkgs.git}/bin/git rev-parse --show-toplevel 2>/dev/null || pwd -P)
          case "$KIMI_SANDBOX_DIR" in
            / | "$HOME")
              echo "kimi: refusing to expose $KIMI_SANDBOX_DIR, start it from a project dir" >&2
              exit 1
              ;;
          esac
          export KIMI_SANDBOX_DIR
          exec ${sandboxed}/bin/kimi "$@"
        '';
      in {
        packages = [kimi];

        persist.directories = [".kimi-code"];
      })
    ];
  };
}
