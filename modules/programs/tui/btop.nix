# Btop is a resource monitor
{
  aspects,
  config,
  ...
}: let
  c = config.theme.withHashtag;
in {
  flake.modules.nixos.btop = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        pkgs,
        scripts,
        ...
      }: let
        btopPackage = pkgs.btop.override {cudaSupport = true;};
      in {
        packages = [
          btopPackage
          (pkgs.makeDesktopItem {
            name = "btop";
            desktopName = "btop++";
            exec = "${scripts.term}/bin/term ${btopPackage}/bin/btop";
            comment = "Ressources monitor (btop)";
            categories = ["Settings"];
            terminal = false;
            keywords = ["ressource" "ressources" "btop" "usage" "monitoring" "cpu" "gpu" "memory"];
          })
        ];

        xdg.config.files."btop/btop.conf".text = ''
          color_theme = "nixy"
          shown_boxes = "cpu mem net proc gpu0"
          vim_keys = True
        '';

        xdg.config.files."btop/themes/nixy.theme".text = ''
          theme[main_bg]="${c.base00}"
          theme[main_fg]="${c.base05}"
          theme[title]="${c.base05}"
          theme[hi_fg]="${c.base0D}"
          theme[selected_bg]="${c.base03}"
          theme[selected_fg]="${c.base0D}"
          theme[inactive_fg]="${c.base04}"
          theme[graph_text]="${c.base06}"
          theme[meter_bg]="${c.base03}"
          theme[proc_misc]="${c.base06}"
          theme[cpu_box]="${c.base0E}"
          theme[mem_box]="${c.base0B}"
          theme[net_box]="${c.base0C}"
          theme[proc_box]="${c.base0D}"
          theme[div_line]="${c.base01}"
          theme[temp_start]="${c.base0B}"
          theme[temp_mid]="${c.base0A}"
          theme[temp_end]="${c.base08}"
          theme[cpu_start]="${c.base0B}"
          theme[cpu_mid]="${c.base0A}"
          theme[cpu_end]="${c.base08}"
          theme[free_start]="${c.base0A}"
          theme[free_mid]="${c.base0B}"
          theme[free_end]="${c.base0B}"
          theme[cached_start]="${c.base0C}"
          theme[cached_mid]="${c.base0C}"
          theme[cached_end]="${c.base0A}"
          theme[available_start]="${c.base08}"
          theme[available_mid]="${c.base0A}"
          theme[available_end]="${c.base0B}"
          theme[used_start]="${c.base0A}"
          theme[used_mid]="${c.base09}"
          theme[used_end]="${c.base08}"
          theme[download_start]="${c.base0B}"
          theme[download_mid]="${c.base0A}"
          theme[download_end]="${c.base08}"
          theme[upload_start]="${c.base0B}"
          theme[upload_mid]="${c.base0A}"
          theme[upload_end]="${c.base08}"
          theme[process_start]="${c.base0B}"
          theme[process_mid]="${c.base0A}"
          theme[process_end]="${c.base08}"
        '';
      })
    ];
  };
}
