-- Wallpaper.lua

  -- At least you need to choose one of them

-- MPVPAPER
-- hl.exec_cmd("mpvpaper -o 'loop-file=inf no-audio hwdec=auto' ALL ~/Videos/Wallpapers/default.mp4") -- Mpvpaper is a wallpaper manager for videos. ALL can be change by your actuall monitor name. 

-- If you want change the wallpaper, go to this file chang the name of the wallpaper you want to have in bg. Use pkill mpvpaper, and hyprctl reload 


-- AWWW 
--hl.exec_cmd("awww-daemon") -- Awww is a desktop wallpaper manager for img and gifs
-- If your goal is to use awww. Comment mpvpaper line and reboot your pc. Awww daemon will start of the next launch of hyprland.
-- With awww, use the command awww img path to the wallpaper

-- HYPRPAPER my beloved 

hl.exec_cmd("hyprpaper")
