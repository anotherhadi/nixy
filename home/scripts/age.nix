{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;

  add-secrets = pkgs.writeShellScriptBin "add-secrets" ''
    file=$1
    pubkey=$(cat ~/nixy.key | grep "public key" | cut -d':' -f2 | sed 's/ //g')
    ${pkgs.age}/bin/age -r $pubkey -o ~/.config/nixos/home/secrets/$file.age -a $file
  '';

in { home.packages = with pkgs; [ add-secrets ]; }
