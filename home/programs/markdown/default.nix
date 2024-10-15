# Work in progress on another repo
{ pkgs, ... }: {
  home.packages = with pkgs; [ wkhtmltopdf ];
}
