{
  lib,
  pkgs,
  ...
}: let
  defaultApps = {
    text = ["nvim-ghostty.desktop"];
    code = ["nvim-ghostty.desktop"];
    image = ["imv-dir.desktop"];
    audio = ["vlc.desktop"];
    video = ["vlc.desktop"];
    directory = ["elio.desktop"];
    office = ["onlyoffice-desktopeditors.desktop"];
    pdf = ["onlyoffice-desktopeditors.desktop"];
    archive = ["elio.desktop"];
    browser = ["helium.desktop"];
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
    archive = [
      "application/zip"
      "application/x-rar-compressed"
      "application/vnd.rar"
      "application/x-7z-compressed"
      "application/x-tar"
      "application/gzip"
      "application/x-bzip2"
      "application/x-xz"
      "application/x-zstd"
      "application/x-compressed-tar"
    ];
    browser = [
      "text/html"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  nvim-ghostty = pkgs.makeDesktopItem {
    name = "nvim-ghostty";
    desktopName = "Neovim (Ghostty)";
    exec = ''${pkgs.ghostty}/bin/ghostty +new-window --title="Neovim Editor" -e nvim %F'';
    terminal = false;
    categories = ["Development" "TextEditor"];
    mimeTypes = mimeMap.code ++ mimeMap.text;
  };

  associations = lib.listToAttrs (
    lib.flatten (
      lib.mapAttrsToList
      (key: map (type: lib.nameValuePair type defaultApps.${key}))
      mimeMap
    )
  );
in {
  home.packages = [nvim-ghostty];

  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = lib.mapAttrs (_: lib.mkForce) associations;
    };
  };
}
