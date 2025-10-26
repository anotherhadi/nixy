{ stdenv, lib }:

stdenv.mkDerivation {
  pname = "Hornet";
  version = "2.3";

  # Solo incluir archivos que empiecen con "Hornet"
  src = lib.cleanSourceWith {
    filter = name: type:
      let base = baseNameOf name;
      in lib.hasPrefix "Hornet" base;
    src = ./.;
  };

  installPhase = ''
    themeDir=$out/share/icons/Hornet
    cursorDir=$themeDir/cursors

    mkdir -p "$cursorDir"

    # Instalar los cursores X11 convertidos
    for f in Hornet*; do
      if [ -f "$f" ]; then
        install -m 0644 "$f" "$cursorDir/"
      fi
    done

    cd "$cursorDir"

    # Enlaces simbólicos estándar de Xcursor
    ln -sf "Hornet normal"      left_ptr
    ln -sf "Hornet help"        help
    ln -sf "Hornet busy"        wait
    ln -sf "Hornet work"        progress
    ln -sf "Hornet text"        text
    ln -sf "Hornet unavailable" not-allowed
    ln -sf "Hornet vert"        size_ver
    ln -sf "Hornet horz"        size_hor
    ln -sf "Hornet dgn1"        size_bdiag
    ln -sf "Hornet dgn2"        size_fdiag
    ln -sf "Hornet move"        move
    ln -sf "Hornet link"        pointer
    ln -sf "Hornet precision"   cross
    ln -sf "Hornet hand"        hand1
    ln -sf "Hornet alt"         alternate
    ln -sf "Hornet location"    pencil
    ln -sf "Hornet person"      person

    # Crear index.theme
    cat > "$themeDir/index.theme" <<EOF
[Icon Theme]
Name=Hornet
Comment=Animated Hollow Knight Hornet cursor theme (X11/Wayland)
Inherits=Adwaita

[Cursor Theme]
Name=Hornet
Comment=Animated Hornet cursor (converted from Windows to X11)
Example=left_ptr
EOF
  '';

  meta = with lib; {
    description = "Hollow Knight Hornet animated cursor theme (X11/Wayland) Designed by NOiiRE https://ko-fi.com/s/2e08ca3a58";
    license = licenses.free;
    platforms = platforms.linux;
  };
}
