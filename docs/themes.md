## Settings, Themes and colors

*Nixy Theme:*

Font:
   Default: SF Apple
   Mono: MesloLG Nerd Font
   GTK Theme: FlatColor (Based on the colors in variables.nix)
   QT Theme: Follow GTK
   Icons:
   Cursor:

*Create your own:*

In your hosts configuration, you should add a `variables.nix` file to manage your settings, including:

- user information
- timezone and locale
- keyboard layout
- the theme: will be used in programs and for GTK and QT themes
- ... (check the `hosts/guest/variables.nix` file for more information)

PS: To apply the theme to duckduckgo, follow the instructions in `$HOME/.duckduckgo-colorscheme.js`.

