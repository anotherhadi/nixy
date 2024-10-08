{ pkgs, ... }: {
  programs.nixvim.plugins.dap = {
    enable = true;
    adapters = { };
    signs = {
      dapBreakpoint = {
        text = "●";
        texthl = "DapBreakpoint";
      };
      dapBreakpointCondition = {
        text = "●";
        texthl = "DapBreakpointCondition";
      };
      dapLogPoint = {
        text = "◆";
        texthl = "DapLogPoint";
      };
    };
    extensions = {
      dap-go = {
        enable = true;
        delve.path = "${pkgs.delve}/bin/dlv";
      };
      dap-ui = { enable = true; };
      dap-virtual-text = { enable = true; };
    };
  };
}
