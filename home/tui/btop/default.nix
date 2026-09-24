{pkgs, ...}: let
  btopPackage = pkgs.btop.override {cudaSupport = true;};
in {
  programs.btop = {
    enable = true;
    package = btopPackage;
    settings = {
      vim_keys = true;
      shown_boxes = "cpu mem net proc gpu0";
    };
  };

  xdg.desktopEntries.btop = {
    name = "btop++";
    exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${btopPackage}/bin/btop";
    comment = "Ressources monitor (btop)";
    categories = ["Settings"];
    terminal = false;
    settings.Keywords = "ressource;ressources;btop;usage;monitoring;cpu;gpu;memory";
  };
}
