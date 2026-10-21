{pkgs}:
pkgs.writeShellApplication {
  name = "wordlists-fetch";
  runtimeInputs = with pkgs; [coreutils curl git gnutar gzip jq util-linux];
  text = ''
    dest="$HOME/Cyber/wordlists"
    mkdir -p "$dest"
    exec 9>"$dest/.lock"
    flock -n 9 || { echo "wordlists-fetch already running"; exit 0; }

    # Missing
    missing() {
      if [ -L "$1" ] && [[ "$(readlink "$1")" == /nix/store/* ]]; then rm "$1"; fi
      [ ! -e "$1" ]
    }

    clone() { # <url> <path>
      missing "$dest/$2" || return 0
      echo "clone $2"
      rm -rf "$dest/$2.part"
      git clone --quiet --depth 1 "$1" "$dest/$2.part"
      mv "$dest/$2.part" "$dest/$2"
    }

    fetch() { # <url> <path>
      missing "$dest/$2" || return 0
      echo "fetch $2"
      mkdir -p "$(dirname "$dest/$2")"
      curl -fsSL --retry 3 -o "$dest/$2.part" "$1"
      mv "$dest/$2.part" "$dest/$2"
    }

    clone https://github.com/danielmiessler/SecLists seclists
    clone https://github.com/0xPugal/fuzz4bounty fuzz4bounty

    # Rules
    clone https://github.com/stealthsploit/oneruletorulethemstill rules/oneruletorulethemstill
    fetch "https://raw.githubusercontent.com/CarlosLannister/OwadeReborn/refs/heads/master/owade/fileAnalyze/hashcatLib/best64.rule%7E" rules/best64.rule

    # Assetnote: the manifests list the latest monthly build of each list
    # Saved without the date suffix so a file already there counts as present
    cdn=https://wordlists-cdn.assetnote.io/data
    for set in automated technologies manual; do
      curl -fsSL --retry 3 "$cdn/$set.json" | jq -r '.data[].Filename' | while read -r file; do
        fetch "$cdn/$set/$file" "assetnote/$set/$(sed -E 's/_[0-9]{4}_[0-9]{2}_[0-9]{2}\.txt$/.txt/' <<<"$file")"
      done
    done

    # Kiterunner: compiled .kite route lists + the plain-text swagger paths
    fetch "$cdn/kiterunner/swagger-wordlist.txt" assetnote/kiterunner/swagger-wordlist.txt
    for kite in routes-small routes-large; do
      if missing "$dest/assetnote/kiterunner/$kite.kite"; then
        echo "fetch assetnote/kiterunner/$kite.kite"
        curl -fsSL --retry 3 "$cdn/kiterunner/$kite.kite.tar.gz" | tar -xzO "$kite.kite" >"$dest/assetnote/kiterunner/$kite.kite.part"
        mv "$dest/assetnote/kiterunner/$kite.kite.part" "$dest/assetnote/kiterunner/$kite.kite"
      fi
    done
  '';
}
