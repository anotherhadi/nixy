# Mime type associations for the system.
{
  lib,
  pkgs,
  ...
}:
with lib; let
  defaultApps = {
    # check desktop files here: `ls $(echo $XDG_DATA_DIRS| sed "s/:/ /g")`
    browser = ["brave.desktop"];
    text = [
      # "org.gnome.TextEditor.desktop"
      "nvim-ghostty.desktop"
    ];
    code = ["nvim-ghostty.desktop"];
    image = ["imv-dir.desktop"];
    audio = ["mpv.desktop"];
    video = ["mpv.desktop"];
    directory = ["thunar.desktop"];
    office = ["libreoffice.desktop"];
    pdf = ["zathura.desktop"];
    terminal = ["ghostty.desktop"];
    discord = ["discord.desktop"];
    archive = ["xarchiver.desktop"];
  };

  mimeMap = {
    text = ["text/plain"];
    code = [
      "text/x-csrc"
      "text/x-chdr"
      "text/x-c++src"
      "text/x-c++hdr"
      "text/x-rust"
      "text/x-go"
      "text/x-java"
      "text/x-csharp"

      "text/x-python"
      "application/x-shellscript"
      "text/javascript"
      "application/javascript"
      "text/css"
      "text/x-php"
      "text/x-ruby"

      "application/json"
      "application/xml"
      "text/xml"
      "text/x-yaml"
      "application/x-yaml"
      "application/toml"
      "text/x-nix"
      "text/markdown"

      "text/x-dockerfile"
      "application/x-yaml"
      "text/x-terraform"

      "application/x-perl"
      "text/x-lua"
      "text/x-haskell"
    ];
    image = [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/jpg"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/vnd.microsoft.icon"
      "image/webp"
    ];
    audio = [
      "audio/aac"
      "audio/mpeg"
      "audio/ogg"
      "audio/opus"
      "audio/wav"
      "audio/webm"
      "audio/x-matroska"
    ];
    video = [
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/webm"
      "video/x-flv"
      "video/x-matroska"
      "video/x-msvideo"
    ];
    directory = ["inode/directory"];
    browser = [
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
    ];
    office = [
      "application/vnd.oasis.opendocument.text"
      "application/vnd.oasis.opendocument.spreadsheet"
      "application/vnd.oasis.opendocument.presentation"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/msword"
      "application/vnd.ms-excel"
      "application/vnd.ms-powerpoint"
      "application/rtf"
    ];
    pdf = ["application/pdf"];
    terminal = ["terminal"];
    archive = [
      "application/zip"
      "application/rar"
      "application/7z"
      "application/*tar"
    ];
    discord = ["x-scheme-handler/discord"];
  };

  nvim-ghostty = pkgs.makeDesktopItem {
    name = "nvim-ghostty";
    desktopName = "Neovim (Ghostty)";
    exec = ''ghostty --title="Neovim Editor" -e nvim %F'';
    terminal = false;
    categories = ["Development" "TextEditor"];
    mimeTypes = mimeMap.code ++ mimeMap.text;
  };

  associations = with lists;
    listToAttrs (flatten (mapAttrsToList
      (key: map (type: attrsets.nameValuePair type defaultApps."${key}"))
      mimeMap));
in {
  home.packages = [nvim-ghostty];

  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
