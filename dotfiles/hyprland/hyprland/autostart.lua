-- autostart.lua

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function ()
  hl.exec_cmd("ghostty") -- Terminal
  hl.exec_cmd("qs") -- quishell bar
  hl.exec_cmd("hyprpaper")
end)
