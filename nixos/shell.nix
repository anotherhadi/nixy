{
  pkgs,
  gitHooksLib,
}: let
  hooks = gitHooksLib.run {
    src = ./.;
    hooks = {
      inject-exec = {
        enable = true;
        name = "inject-exec";
        entry = "python3 .github/scripts/inject-exec.py README.md";
        language = "system";
        files = "(README\\.md)";
        pass_filenames = false;
      };

      doctoc = {
        enable = true;
        name = "doctoc";
        entry = "doctoc --notitle README.md";
        language = "system";
        files = "(README\\.md)";
        pass_filenames = false;
      };
    };
  };
in
  pkgs.mkShell {
    packages = with pkgs;
      [
        doctoc
        python3
      ]
      ++ hooks.enabledPackages;

    shellHook = hooks.shellHook;
  }
