# Mime allows us to configure the default applications for each file type
{
  xdg = {
    enable = true;
    mime.enable = true;
    userDirs.enable = true;
    portal.xdgOpenUsePortal = true;
    configFile."mimeapps.list".force =
      true; # don't error when mimeapps.list is replaced, it gets replaced often
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/markdown" = "nvim.desktop";
        "text/plain" = "nvim.desktop";
        "text/x-shellscript" = "nvim.desktop";
        "text/x-python" = "nvim.desktop";
        "text/x-go" = "nvim.desktop";
        "text/css" = "nvim.desktop";
        "text/javascript" = "nvim.desktop";
        "text/x-c" = "nvim.desktop";
        "text/x-c++" = "nvim.desktop";
        "text/x-java" = "nvim.desktop";
        "text/x-rust" = "nvim.desktop";
        "text/x-yaml" = "nvim.desktop";
        "text/x-toml" = "nvim.desktop";
        "text/x-dockerfile" = "nvim.desktop";
        "text/x-xml" = "nvim.desktop";
        "text/x-php" = "nvim.desktop";
        "image/jpeg" = "imv.desktop";
        "image/jpg" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "image/gif" = "zen.desktop";
        "inode/directory" = "thunar.desktop";
        "application/pdf" = "zathura.desktop";
        "image/png" = "imv-dir.desktop";

        "x-scheme-handler/http" = "userapp-Zen-64DC42.desktop";
        "x-scheme-handler/https" = "userapp-Zen-64DC42.desktop";
        "x-scheme-handler/chrome" = "userapp-Zen-64DC42.desktop";
        "text/html" = "userapp-Zen-64DC42.desktop";
        "application/x-extension-htm" = "userapp-Zen-64DC42.desktop";
        "application/x-extension-html" = "userapp-Zen-64DC42.desktop";
        "application/x-extension-shtml" = "userapp-Zen-64DC42.desktop";
        "application/xhtml+xml" = "userapp-Zen-64DC42.desktop";
        "application/x-extension-xhtml" = "userapp-Zen-64DC42.desktop";
        "application/x-extension-xht" = "userapp-Zen-64DC42.desktop";
      };
    };
  };
}
