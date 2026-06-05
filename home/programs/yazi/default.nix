{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    plugins = {
      git     = { package = pkgs.yaziPlugins.git;     setup = true; };
      ouch    = pkgs.yaziPlugins.ouch;
      piper   = pkgs.yaziPlugins.piper;
      convert = pkgs.yaziPlugins.convert;
    };

    settings.plugin = {
      prepend_fetchers = [
        { url = "*";  run = "git"; group = "git"; }
        { url = "*/"; run = "git"; group = "git"; }
      ];
      prepend_previewers = [
        { url = "*.md"; run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"''; }
      ];
      prepend_openers = [
        { url = "*.{zip,tar,gz,bz2,xz,7z,rar}"; run = "ouch"; }
      ];
    };

    keymap.mgr.prepend_keymap = [
      { on = ["C"]; run = "plugin ouch";            desc = "Compress"; }
      { on = ["X"]; run = "plugin ouch --args=extract"; desc = "Extract"; }
      { on = ["c" "p"]; run = "plugin convert -- --extension='png'";  desc = "Convert to PNG"; }
      { on = ["c" "j"]; run = "plugin convert -- --extension='jpg'";  desc = "Convert to JPG"; }
      { on = ["c" "w"]; run = "plugin convert -- --extension='webp'"; desc = "Convert to WebP"; }
    ];
  };

  home.packages = with pkgs; [ glow ouch hexyl ];
}
