{ pkgs, config, ... }: {
  home.packages = with pkgs; [ pistol ];

  programs.lf = {
    enable = true;

    commands = {
      dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
      editor-open = "$$EDITOR $f";
      mkdir = ''
        ''${{
          printf "Directory Name: "
          read DIR
          mkdir $DIR
        }}
      '';
    };

    keybindings = {
      d = "delete";
      x = "cut";
      "<enter>" = "open";
      "<c-g>" = "quit";
      "<esc>" = "quit";
      "H" = "set hidden!";
      "\\\"" = "";
      o = "";
      c = "mkdir";
      "." = "set hidden!";
      "`" = "mark-load";
      "\\'" = "mark-load";
      "g~" = "cd";
      do = "dragon-out";
      gh = "cd";
      "g/" = "/";
      ee = "editor-open";
      V = ''$''${pkgs.bat}/bin/bat --paging=always "$f"'';
    };

    settings = {
      ratios = [ 1 1 2 ];
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
      incsearch = true;
    };

    previewer.source = "${pkgs.pistol}/bin/pistol";

    extraConfig = let
      previewer = pkgs.writeShellScriptBin "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            exit 1
        fi

        ${pkgs.pistol}/bin/pistol "$file"
      '';
      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
      '';
    in ''
      set cleaner ${cleaner}/bin/clean.sh
      set previewer ${previewer}/bin/pv.sh
    '';
  };

  xdg.configFile."lf" = {
    recursive = true;
    source = ./config;
  };
}
