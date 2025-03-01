{ lib, ... }:
{
  programs.nvf.settings = {
    vim = {
      mini = {
        icons.enable = true;
        statusline.enable = true;
        git.enable = true;
        diff.enable = true;
        align.enable = true;
        notify.enable = true;
        operators.enable = true;
        starter.enable = true;
        comment.enable = true;
        move.enable = true;
        pairs.enable = true;
        splitjoin.enable = true;
        bracketed.enable = true;
        indentscope = {
          enable = true;
          setupOpts.draw.animation = lib.generators.mkLuaInline ''require("mini.indentscope").gen_animation.none()'';
        };
      };

      keymaps = [
      ];
    };
  };
}
