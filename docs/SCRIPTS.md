# Scripts

Scripts are located in the `home/scripts` folder. Home-manager add those in the path.

## Nix/NixOs shortcuts

> [!TIP]
> The `hostname` variable in `hosts/yourhost/variables.nix` should be also the name of the `nixosConfiguration` in `flake.nix` file.

- `nixy` # UI
- `nixy rebuild`
- `nixy update`
- `nixy upgrade`
- `nixy gc` # garbage collection
- `nixy cb` # clean boot menu

## Brightness control

- `brightness-up`
- `brightness-down`
- `brightness-change <up/down> <increment>`

## Sound control

- `sound-up`
- `sound-down`
- `sound-toggle`
- `sound-output`
- `sound-change [up/down/mute] <increment>`

## Caffeine

Caffeine is a simple script that toggles hypridle (disable suspend & screenlock).

- `caffeine` # Toggle caffeine
- `caffeine-status` # Return active/inactive

## Night-Shift

Blue light filter, using wlsunset

- `night-shift` # Toggle night shift
- `night-shift-status` # Return active/inactive
- `night-shift-on`
- `night-shift-off`

## Nerdfont FZF

Nerdfont fzf is a quick way to search for nerdfont icons locally.
It will copy the selected icon to the clipboard.

- `nerdfont-fzf`

## Compress/Extract

Some shortcuts to compress and extract files.

- `compress` ...
- `extract` ...
