# Bookmark tree shared by the startpage and the managed bookmarks policy
# Items are {name, url} or folders {name, icon?, bookmarks = [...]}
(import ./general.nix)
++ (import ./tools.nix)
++ (import ./entertainment.nix)
++ (import ./infosec.nix)
++ (import ./other.nix)
++ (import ./jack.nix)
