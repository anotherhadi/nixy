require("dashboard").setup({
  theme = "hyper",
  config = {
    header = {
      "",
      "  ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
      "  ████╗  ██║██║   ██║██║████╗ ████║",
      "  ██╔██╗ ██║██║   ██║██║██╔████╔██║",
      "  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      "",
    },
    shortcut = {
      { desc = "  Find File", group = "Label", action = "Telescope find_files", key = "f" },
      { desc = "  Quit", group = "DiagnosticError", action = "qa", key = "q" },
    },
    project = {
      enable = true,
      limit = 8,
      icon = "  ",
      label = "Recent Projects",
      action = "Telescope find_files cwd=",
    },
    mru = {
      enable = true,
      limit = 10,
      icon = "  ",
      label = "Recent Files",
      cwd_only = false,
    },
    footer = {
      "",
      " Powered by lua "
    }
  },
})
