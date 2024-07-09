{ lib, ... }: {
  options = {
    var = {
      hostname = lib.mkOption {
        type = lib.types.string;
        default = "nixy";
        description = "Hostname";
      };
      username = lib.mkOption {
        type = lib.types.string;
        default = "user";
        description = "Username";
      };
      homeDirectory = lib.mkOption {
        type = lib.types.string;
        default = "/home/user";
        description = "Home directory (/home/user)";
      };
      configDirectory = lib.mkOption {
        type = lib.types.string;
        default = "/home/user/.config/nixos";
        description = "NixOS config directory (/home/user/.config/nixos)";
      };
      keyboardLayout = lib.mkOption {
        type = lib.types.string;
        default = "en";
        description = "Keyboard layout (en/fr/...)";
      };
      timeZone = lib.mkOption {
        type = lib.types.string;
        default = "America/New_York";
        description = "Time Zone";
      };
      defaultLocale = lib.mkOption {
        type = lib.types.string;
        default = "en_US.UTF-8";
        description = "Default Locale";
      };
      extraLocale = lib.mkOption {
        type = lib.types.string;
        default = "fr_FR.UTF-8";
        description = "Extra Locale";
      };
      stateVersion = lib.mkOption {
        type = lib.types.string;
        default = "24.05";
        description = "State Version: Shouldn't be changed once set.";
      };
      autoUpgrade = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable auto upgrades";
      };
      autoGarbageCollector = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable garbage collector";
      };
      sops = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description =
          "Enable sops (You should set up sops for your own config)";
      };
      obsidian = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description =
          "Enable obsidian.nvim (You should set up obsidian.nvim for your own config)";
      };
      tailscale = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable tailscale";
      };
      git = {
        username = lib.mkOption {
          type = lib.types.string;
          default = "user";
          description = "Git Username";
        };
        email = lib.mkOption {
          type = lib.types.string;
          default = "youremail@gmail.com";
          description = "Git Email";
        };
      };
      theme = {
        wallpaper = lib.mkOption {
          type = lib.types.string;
          default = "magma.png";
          description = "Wallpaper (Should be in /home/$USER/wallpapers)";
        };
        font = lib.mkOption {
          type = lib.types.string;
          default = "SFProDisplay Nerd Font";
          description = "Font";
        };
        font-mono = lib.mkOption {
          type = lib.types.string;
          default = "FiraCode Nerd Font Mono";
          description = "Monospace Font";
        };
        font-size = lib.mkOption {
          type = lib.types.int;
          default = 14;
          description = "Font Size";
        };
        rounding = lib.mkOption {
          type = lib.types.int;
          default = 8;
          description = "Border radius";
        };      
        gaps-in = lib.mkOption {
          type = lib.types.int;
          default = 8;
          description = "Gaps In";
        };  
        gaps-out = lib.mkOption {
          type = lib.types.int;
          default = 16;
          description = "Gaps Out";
        };  
        border-size = lib.mkOption {
          type = lib.types.int;
          default = 2;
          description = "Border Size";
        };  
        animation-speed = lib.mkOption {
          type = lib.types.string;
          default = "medium";
          description = "Animation Speed (slow/medium/fast)";
        };
        fetch = lib.mkOption {
          type = lib.types.string;
          default = "neofetch";
          description = "Fetch (neofetch/nerdfetch/pfetch/none)";
        };
        waybar = {
          transparent = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Transparent Bar";
          };
          float = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Floating Bar";
          };
          position = lib.mkOption {
            type = lib.types.string;
            default = "top";
            description = "Bar's Position";
          };
          font-size = lib.mkOption {
            type = lib.types.int;
            default = 16;
            description = "Waybar text font size";
          };
        };
        colors = {
          # TODO
        };
      };
    };
  };
}