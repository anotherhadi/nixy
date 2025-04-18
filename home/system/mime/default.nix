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
        "inode/directory" = "thunar.desktop";
        "application/pdf" = "zathura.desktop";
        "image/png" = "imv-dir.desktop";

        "image/gif" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/chrome" = "zen-beta.desktop";
        "text/html" = "zen-beta.desktop";
        "application/x-extension-htm" = "zen-beta.desktop";
        "application/x-extension-html" = "zen-beta.desktop";
        "application/x-extension-shtml" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";
        "application/x-extension-xhtml" = "zen-beta.desktop";
        "application/x-extension-xht" = "zen-beta.desktop";
      };
    };
  };
}
