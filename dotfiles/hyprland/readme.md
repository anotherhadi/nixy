## using waybar in hyprland 
Type waybar into your terminal. In order to have Waybar launch alongside Hyprland, add this line to your Hyprland configuration:

exec-once = waybar


Waybar also provides a systemd service. If you use Hyprland with uwsm, you can enable it, using the following command.

systemctl --user enable --now waybar.service

## Adding the Hyprland's stub

In version 0.55, config file are in lua. 
But i use a lsp for lua, so i need to add the Hyprland's stub. You can find the configuration file of lsp at the root of .config/hypr/.luarc.json

> Btw: stub is a file that describes what functions and types exist, without actually doing anything.

## Audio drivers 

If you have an hp pc model, or anything else, you may need download some firwmware to download. 
For exemple on hp computer. 
```bash 
sudo dmesg | grep snd 
```
output: 
``` 
[    4.952484] snd_hda_intel 0000:00:1f.3: Digital mics found on Skylake+ platform, using SOF driver
[    4.952540] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[    4.952638] snd_hda_intel 0000:01:00.1: Disabling MSI
[    4.952641] snd_hda_intel 0000:01:00.1: Handle vga_switcheroo audio client
[    4.979311] snd_hda_intel 0000:01:00.1: bound 0000:01:00.0 (ops nv50_audio_component_bind_ops [nouveau])

```
You need to download SOF driver to use it (first ouput line)
