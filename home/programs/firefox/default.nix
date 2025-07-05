{ config, pkgs, lib, ... }:

let
  HOME = config.home.homeDirectory;
  FF_BASE = "${HOME}/.mozilla/firefox";
in
{
  programs.firefox = {
    enable = true;
  };

  home.activation.firefoxUserChrome = lib.mkAfter ''
    # найдём первый профиль (обычно *.default-release или *.default)
    PROFILE=$(ls ${FF_BASE}/*.default* 2>/dev/null | head -n1)
    if [ -z "$PROFILE" ]; then
      echo "WARNING: Firefox profile not found in ${FF_BASE}, skip userChrome.css"
      exit 0
    fi

    mkdir -p "$PROFILE/chrome"
    cat > "$PROFILE/chrome/userChrome.css" <<'EOF'
    /* Центрируем панель закладок */
    @-moz-document url(chrome://browser/content/browser.xhtml) {
      #PersonalToolbar {
        display: flex !important;
        justify-content: center !important;
      }
    }
    EOF
  '';

  # Остальные ваши home-manager-настройки...
}

