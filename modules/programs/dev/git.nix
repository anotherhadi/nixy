# Git configuration (git, gh, lazygit)
{
  aspects,
  config,
  lib,
  ...
}: let
  c = config.theme.withHashtag;
in {
  flake.modules.nixos.git = {
    imports = [aspects.hjem];

    options.nixy.git = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Git author name of the host's user";
      };
      email = lib.mkOption {
        type = lib.types.str;
        description = "Git author email of the host's user";
      };
    };

    config.hjem.extraModules = [
      ({
        lib,
        pkgs,
        options,
        osConfig,
        ...
      }: let
        ghHelper = ["" "${pkgs.gh}/bin/gh auth git-credential"];
      in {
        config = lib.mkMerge [
          {
            packages = with pkgs; [git gh lazygit];

            xdg.config.files."git/config" = {
              # includeIf sections go last: git keeps the last value read, so an
              # included identity must come after [user] to override it
              generator = value: let
                includes = value.includeIf or {};
              in
                lib.generators.toGitINI (removeAttrs value ["includeIf"])
                + lib.optionalString (includes != {}) ("\n" + lib.generators.toGitINI {includeIf = includes;});
              value = {
                user = {
                  name = osConfig.nixy.git.name;
                  email = osConfig.nixy.git.email;
                };
                init.defaultBranch = "main";
                pull.rebase = "true";
                push.autoSetupRemote = true;
                color.ui = "1";
                credential."https://github.com".helper = ghHelper;
                credential."https://gist.github.com".helper = ghHelper;
                alias = {
                  co = "checkout";
                  fuck = "commit --amend -m";
                  c = "commit -m";
                  ca = "commit -am";
                  forgor = "commit --amend --no-edit";
                  graph = "log --all --decorate --graph --oneline";
                  oops = "checkout --";
                  l = "log";
                  r = "rebase";
                  s = "status --short";
                  ss = "status";
                  d = "diff";
                  ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
                  pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
                  st = "status";
                  br = "branch";
                  hist = ''log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all'';
                  llog = ''log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative'';
                };
              };
            };

            xdg.config.files."git/ignore".text = lib.concatLines [
              ".cache/"
              ".DS_Store"
              ".idea/"
              "*.swp"
              "*.elc"
              "auto-save-list"
              ".direnv/"
              "node_modules"
              "result"
              "result-*"
              ".superpowers/"
              ".claude/"
              "docs/superpowers/"
            ];

            xdg.config.files."gh/config.yml" = {
              generator = (pkgs.formats.yaml {}).generate "gh-config.yml";
              value = {
                version = "1";
                git_protocol = "https";
                editor = "";
                aliases = {};
              };
            };

            # Lazygit is a simple terminal UI for git commands.
            xdg.config.files."lazygit/config.yml" = {
              generator = (pkgs.formats.yaml {}).generate "lazygit-config.yml";
              value = {
                disableStartupPopups = true;
                notARepository = "skip";
                promptToReturnFromSubprocess = false;
                update.method = "never";
                git = {
                  commit.signOff = true;
                  overrideGpg = true;
                  parseEmoji = true;
                };
                gui = {
                  theme = {
                    activeBorderColor = [c.base0D "bold"];
                    inactiveBorderColor = [c.base03];
                  };
                  showListFooter = false;
                  showRandomTip = false;
                  showCommandLog = false;
                  showBottomLine = false;
                  nerdFontsVersion = "3";
                };
              };
            };

            persist.directories = [".config/gh"];
          }

          (lib.optionalAttrs (options ? zsh) {
            # lg: lazygit, then cd into the repo it was left in
            zsh.initContent = lib.mkOrder 1100 ''
              function lg() {
                  export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
                  command lazygit "$@"
                  if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
                    cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
                    rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
                  fi
              }
            '';
          })
        ];
      })
    ];
  };

  # Sign commits with an SSH key
  # CHANGEME: change this to your own SSH key.
  # The key pair comes from the host's sops file (signing-key, signing-pub-key)
  flake.modules.nixos.git-signing = {config, ...}: let
    username = config.nixy.username;
    home = config.users.users.${username}.home;
    keys = ["signing-key" "signing-pub-key"];
  in {
    imports = [
      aspects.git
      aspects.secrets
    ];

    assertions =
      map (key: {
        assertion = builtins.elem key config.nixy.secrets.available;
        message = "git-signing: the host's sops file has no `${key}` secret";
      })
      keys;

    sops.secrets = {
      signing-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/key";
      };
      signing-pub-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/key.pub";
      };
    };

    hjem.extraModules = [
      {
        files.".ssh/allowed_signers".text = "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINhWby7lUUXQNKbRu9/UOrGjWDf3fvoAwGHomWv/+lL";

        xdg.config.files."git/config".value = {
          commit.gpgsign = true;
          gpg.format = "ssh";
          gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
          user.signingkey = "~/.ssh/key.pub";
        };
      }
    ];
  };
}
