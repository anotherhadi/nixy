-- env.lua 

--file for environement variable

local env = {
  { "XCURSOR_SIZE", "24" },
  { "HYPRCURSOR_SIZE", "24" },

  -- Priority to wayland engine
  { "GDK_BACKEND", "wayland,x11,*" },
  { "QT_QPA_PLATFORM", "wayland;xcb" },
  { "SDL_VIDEODRIVER", "wayland" },
  { "CLUTTER_BACKEND", "wayland" },

  -- XDG Specifications
  { "XDG_CURRENT_DESKTOP", "Hyprland" },
  { "XDG_SESSION_TYPE", "wayland" },
  { "XDG_SESSION_DESKTOP", "Hyprland" },
}

local function apply_env(list)
  for _, pair in ipairs(list) do
    hl.env(pair[1], tostring(pair[2]))
  end
end

apply_env(env)
