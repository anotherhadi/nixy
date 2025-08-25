# Lazygit is a simple terminal UI for git commands.
{
  config,
  lib,
  ...
}: let
  accent = "#${config.lib.stylix.colors.base0D}";
  muted = "#${config.lib.stylix.colors.base03}";
in {
  programs.lazygit = {
    enable = true;
    settings = lib.mkForce {
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
          activeBorderColor = [accent "bold"];
          inactiveBorderColor = [muted];
        };
        showListFooter = false;
        showRandomTip = false;
        showCommandLog = false;
        showBottomLine = false;
        nerdFontsVersion = "3";
      };
    };
  };
}
