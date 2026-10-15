# MIME types by category, and a helper so each application declares what it opens:
#   hjem: xdg.mime-apps = config.flake.lib.mime.defaultFor "kew.desktop" mime.types.audio;
{lib, ...}: {
  flake.lib.mime = {
    types = {
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
        "image/png"
        "image/svg+xml"
        "image/tiff"
        "image/vnd.microsoft.icon"
        "image/webp"
        "image/heif"
        "image/avif"
      ];
      audio = [
        "audio/aac"
        "audio/mpeg"
        "audio/ogg"
        "audio/opus"
        "audio/vnd.wave"
        "audio/webm"
        "audio/x-matroska"
        "audio/flac"
        "audio/mp4"
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
        "video/quicktime"
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
        "application/x-bzip2-compressed-tar"
        "application/x-xz-compressed-tar"
      ];
      browser = [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/ftp"
      ];
    };

    defaultFor = desktopFile: types: let
      associations = lib.genAttrs types (_: [desktopFile]);
    in {
      added-associations = associations;
      default-applications = associations;
    };
  };
}
