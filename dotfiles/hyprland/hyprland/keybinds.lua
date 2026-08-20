-- keybinds.lua

local mainMod = "SUPER"

-- Apps
hl.bind(mainMod .. " + A",           hl.dsp.exec_cmd(Terminal))
hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd(FileManager))
hl.bind(mainMod .. " + R",           hl.dsp.exec_cmd(Menu))
hl.bind(mainMod .. " + B",           hl.dsp.exec_cmd(Browser .. " --new-window"))
hl.bind(mainMod .. " + SHIFT + B",   hl.dsp.exec_cmd(Browser .. " --private-window"))

-- Session
hl.bind(mainMod .. " + M",           hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + L",           hl.dsp.exec_cmd("hyprlock"))

-- Window
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit")) -- Dwindle
hl.bind(mainMod .. " + V",           hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + C",           hl.dsp.window.close())

-- Screenshots
hl.bind(mainMod .. " + P",           hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + SHIFT + P",     hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + O",     hl.dsp.exec_cmd("hyprshot -m output"))

-- Audio (PipeWire)
hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), {locked = true, repeating = true})
hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"), {locked = true, repeating = true})
hl.bind("XF86AudioMute",          hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {locked = true})
hl.bind("XF86AudioMicMute",       hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

-- Screen Brightness
hl.bind("XF86MonBrightnessUp",    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), {locked = true, repeating = true})
hl.bind("XF86MonBrightnessDown",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), {locked = true, repeating = true})

-- Playerctl
hl.bind("XF86AudioNext",           hl.dsp.exec_cmd("playerctl next"), {locked = true })
hl.bind("XF86AudioPause",          hl.dsp.exec_cmd("playerctl play-pause"), {locked = true })
hl.bind("XF86AudioPlay",           hl.dsp.exec_cmd("playerctl play-pause"), {locked = true })
hl.bind("XF86AudioPrev",           hl.dsp.exec_cmd("playerctl previous"), {locked = true })

-- Focus
hl.bind(mainMod .. " + left",        hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right",       hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",          hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",        hl.dsp.focus({ direction = "d" }))

-- Workspaces (QWERTY Keyboard)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Workspaces (clavier AZERTY)
--local fr_keys = {
  --"ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", -- 1..5
  --"minus", "egrave", "underscore", "ccedilla", "agrave", -- 6..10
--}

--for i, key in ipairs(fr_keys) do -- loop on key (start with i = 1)
  -- MOD + key  -> focus workspace i
  --hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  -- MOD + SHIFT + key -> Déplacer fenêtre vers workspace i
  --hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
--end

-- Lid action
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.local/share/quickshell-lockscreen/lock.sh"), {locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"), {locked = true })

-- Scratchpad

-- Scroll workspaces

-- Move/resize avec souris
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.resize(), { mouse = true })
