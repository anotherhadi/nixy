{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    plugins = {
      git = {
        package = pkgs.yaziPlugins.git;
        setup = true;
      };
      ouch = pkgs.yaziPlugins.ouch;
      piper = pkgs.yaziPlugins.piper;
      convert = pkgs.yaziPlugins.convert;
      "full-border" = {
        package = pkgs.yaziPlugins."full-border";
        setup = true;
      };
      "jump-to-char" = pkgs.yaziPlugins."jump-to-char";
      "wl-clipboard" = pkgs.yaziPlugins."wl-clipboard";
      "batch-rename-gui" = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "batch-rename-gui.yazi";
        version = "0-unstable-2025-07-08";
        src = pkgs.fetchFromGitHub {
          owner = "pakhromov";
          repo = "batch-rename-gui.yazi";
          rev = "5c2d5aa349948b6ab405a171541faab44751f6a5";
          hash = "sha256-3RviPY3WOyYi5GWXWRYMWp6VLxCe5cuJX7Kb7AyWxLE=";
        };
      };
    };

    settings.mgr.ratio = [0 4 3];

    settings.plugin = {
      prepend_fetchers = [
        {
          url = "*";
          run = "git";
          group = "git";
        }
        {
          url = "*/";
          run = "git";
          group = "git";
        }
      ];
      prepend_previewers = [
        {
          url = "*.md";
          run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'';
        }
      ];
      prepend_openers = [
        {
          url = "*.{zip,tar,gz,bz2,xz,7z,rar}";
          run = "ouch";
        }
      ];
    };

    keymap.mgr.prepend_keymap = [
      {
        on = ["C"];
        run = "plugin ouch";
        desc = "Compress";
      }
      {
        on = ["X"];
        run = "plugin ouch --args=extract";
        desc = "Extract";
      }
      {
        on = ["c" "p"];
        run = "plugin convert -- --extension='png'";
        desc = "Convert to PNG";
      }
      {
        on = ["c" "j"];
        run = "plugin convert -- --extension='jpg'";
        desc = "Convert to JPG";
      }
      {
        on = ["c" "w"];
        run = "plugin convert -- --extension='webp'";
        desc = "Convert to WebP";
      }
      {
        on = ["M"];
        run = ''shell 'exiftool "$@" | less' --block'';
        desc = "Show metadata";
      }
      {
        on = ["T"];
        run = "plugin toggle-parent";
        desc = "Toggle parent pane";
      }
      {
        on = ["F"];
        run = "plugin jump-to-char";
        desc = "Jump to char";
      }
      {
        on = ["Y"];
        run = "plugin wl-clipboard";
        desc = "Copy to clipboard (Wayland)";
      }
      {
        on = ["B"];
        run = "plugin batch-rename-gui";
        desc = "Batch rename";
      }
      {
        on = [";"];
        run = "plugin command-palette";
        desc = "Command palette";
      }
    ];
  };

  home.packages = with pkgs; [glow ouch hexyl exiftool starship fzf];

  xdg.configFile."yazi/plugins/toggle-parent.yazi/main.lua".text = ''
    --- @sync entry
    local RESTORE_WIDTH = 1
    return {
      entry = function(st, job)
        local r = rt.mgr.ratio
        if r.parent == 0 then
          rt.mgr.ratio = { st.width or RESTORE_WIDTH, r.current, r.preview }
        else
          st.width = r.parent
          rt.mgr.ratio = { 0, r.current, r.preview }
        end
        ya.emit("app:resize", {})
      end
    }
  '';
}
