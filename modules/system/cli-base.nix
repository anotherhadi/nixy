# Base command line tools, available to every user (root included)
{
  flake.modules.nixos.cli-base = {pkgs, ...}: {
    environment = {
      variables = {
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
      };

      systemPackages = with pkgs; [
        fd
        bc
        gcc
        file
        git-ignore
        xdg-utils
        wget
        curl
        gnupg
        openssl
        vim
        go
        zip
        unzip
        optipng
        jpegoptim
        pfetch
        unrar
        p7zip
      ];
    };
  };
}
