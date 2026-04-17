{config, ...}: {
  programs.qutebrowser.keyBindings = {
    normal."<Ctrl-w>" = "tab-close";
    normal."<Ctrl-b>" = "open file://${config.xdg.dataHome}/qutebrowser/bookmarks.html";

    # Ctrl+c is used to leave the current mode and return to normal mode.
    insert."<Ctrl-c>" = "mode-leave";
    hint."<Ctrl-c>" = "mode-leave";
    caret."<Ctrl-c>" = "mode-leave";
    command."<Ctrl-c>" = "mode-leave";
    prompt."<Ctrl-c>" = "mode-leave";
    yesno."<Ctrl-c>" = "mode-leave";
    register."<Ctrl-c>" = "mode-leave";
  };
}
