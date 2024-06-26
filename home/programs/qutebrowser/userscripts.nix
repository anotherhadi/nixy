{ pkgs, ... }: {

  home.packages = with pkgs; [
    keyutils
    python3
    python311Packages.pyperclip
    python312Packages.tldextract
  ];

  xdg.configFile."qutebrowser/userscripts/bitwarden" = {
    source = ./userscripts/qute-bitwarden.py;
    executable = true;
  };
}
