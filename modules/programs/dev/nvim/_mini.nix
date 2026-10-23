{lib, ...}: {
  vim.mini = {
    ai.enable = true;
    starter = {
      enable = true;
      setupOpts = {
        header = ''
          ⣟⣯⣟⣯⡇⠀⣿⢩⣛⡼⣏⠀⠈⠋⠀⣈⡷⣙⢎⡳⣙⢮⣙⢮⣙⢎⡳⣙⢾⣿
          ⢿⡾⣽⡞⣷⣤⣏⡳⡜⡼⠗⠁⢀⠀⠙⢧⠳⣍⢞⡱⣭⠲⣍⠶⣩⢞⡱⡭⣾⣿
          ⠈⠻⠧⢿⣧⣿⠶⣵⢻⢞⡷⢲⡟⡶⢴⡭⢿⣜⣮⡱⢎⡳⣍⢞⡱⢮⡱⣳⣿⣽
          ⠀⣰⣶⡏⢷⣈⣿⣸⣇⣾⣸⣿⣾⣹⣆⡹⡎⡶⢇⡿⣹⢷⣾⣈⠷⣇⢷⣿⣿⣹
          ⣾⣻⣭⣿⣾⣿⣿⣟⣿⣿⡿⣽⡿⣿⢿⣿⣿⣿⣾⣶⣵⣾⠲⣭⢳⣞⣾⡿⣷⣿
          ⣿⣿⣿⣯⣷⣿⣿⠿⢝⠚⠋⠉⠉⠉⠙⠚⠛⡾⢿⣿⣻⣿⣿⣶⣏⠶⣩⠿⣿⡈
          ⣿⣟⣿⣻⣿⡏⠀⠀⠀⠳⡀⠀⠀⠀⠀⠰⠊⠀⠀⠈⠙⠳⣿⣿⣿⣿⣧⣻⣿⣿
          ⠘⢻⣿⣿⣽⡇⠈⠧⣄⠀⠀⠀⠀⠀⠀⢀⣄⡤⠴⠚⠀⠀⠀⠙⢿⣷⡿⣿⣿⣿
          ⠀⠠⢈⢛⣿⠀⠚⠉⠉⠱⣼⡷⠀⠀⠀⠀⠉⠉⠑⠶⠀⠀⠀⠀⠀⠻⣿⣿⣾⢿
          ⠀⠡⠈⠉⠹⡀⠀⠀⡄⠀⣸⡀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣯⣿⢿
          ⠀⠁⢶⣶⠀⢷⠀⠀⠉⠉⠀⠈⠉⠶⠆⠈⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣾⣿
          ⠀⠡⢸⢹⠏⡍⠓⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣺⡟⠋⠉⢹⢭⢣
          ⠀⠀⢸⣹⡏⠭⠭⠭⠙⣲⣦⣤⣤⣀⣀⣀⣀⣤⣤⣶⣞⠉⠙⠛⠷⢀⣀⠘⣎⠧
          ⢁⣈⣀⣀⢀⣀⣀⣀⣼⠟⠹⢿⣯⣟⣿⣻⡿⠿⠛⢿⣿⣦⡀⠀⠀⠀⠀⠉⠉⠘
        '';
        footer = "";
        items = [
          {
            name = "files";
            action = lib.mkLuaInline "function() Snacks.picker.files() end";
            section = "";
          }
          {
            name = "directories";
            action = lib.mkLuaInline "function() Snacks.explorer() end";
            section = "";
          }
          {
            name = "tmp";
            action = lib.mkLuaInline ''
              function()
                local uuid = vim.fn.system("uuidgen"):match("(%S+)")
                vim.cmd("edit /tmp/" .. uuid .. ".md")
              end
            '';
            section = "";
          }
          {
            name = "recent";
            action = lib.mkLuaInline "function() Snacks.picker.recent() end";
            section = "";
          }
        ];
      };
    };
    comment.enable = true;
    icons.enable = true;
    indentscope.enable = true;
    pairs.enable = true;
    diff.enable = true;
    git.enable = true;
    jump2d.enable = true;
    statusline.enable = true;
    clue = {
      enable = true;
      setupOpts = let
        trigger = mode: keys: {inherit mode keys;};
        clue = mode: keys: desc: {inherit mode keys desc;};
        gen = lib.mkLuaInline;
      in {
        triggers = [
          (trigger "n" "<Leader>")
          (trigger "x" "<Leader>")
          (trigger "n" "g")
          (trigger "x" "g")
          (trigger "n" "'")
          (trigger "n" "`")
          (trigger "n" "\"")
          (trigger "i" "<C-r>")
          (trigger "c" "<C-r>")
          (trigger "n" "<C-w>")
          (trigger "n" "z")
        ];
        clues = [
          (gen "require('mini.clue').gen_clues.g()")
          (gen "require('mini.clue').gen_clues.marks()")
          (gen "require('mini.clue').gen_clues.registers()")
          (gen "require('mini.clue').gen_clues.windows({ submode_resize = true })")
          (gen "require('mini.clue').gen_clues.z()")
          (clue "n" "<Leader>f" "+find")
          (clue "n" "<Leader>s" "+search")
          (clue "n" "<Leader>t" "+tools")
          (clue "n" "<Leader>u" "+ui")
          (clue "n" "<Leader>l" "+lsp")
          (clue "n" "<Leader>x" "+trouble")
          (clue "n" "<Leader>!" "shell")
          (clue "v" "<Leader>!" "shell")
        ];
        window.delay = 300;
      };
    };
    surround.enable = true;
  };
}
