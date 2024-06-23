# From https://github.com/Frost-Phoenix/nixos-config
{ pkgs, ... }:
let
  compress = pkgs.writeShellScriptBin "compress" ''
    if (( $# == 1 )) then
        # echo -ne "Archive name: "
        # read name
        # tar -cvzf "$name.tar.gz" $1
        tar -cvzf "$1.tar.gz" $1
    else
        echo "Wrong number of arguments..."
    fi
  '';

  extract = pkgs.writeShellScriptBin "extract" ''
     for i in "$@" ; do
        tar -xvzf $i
        break
    done 
  '';

in { home.packages = [ compress extract ]; }
