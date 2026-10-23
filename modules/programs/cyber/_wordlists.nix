{pkgs}:
pkgs.writeShellApplication {
  name = "wordlists-fetch";
  runtimeInputs = with pkgs; [coreutils curl git gnutar gzip jq util-linux];
  text = ''
    dest="$HOME/Cyber/wordlists"
    mkdir -p "$dest"
    exec 9>"$dest/.lock"
    flock -n 9 || { echo "wordlists-fetch already running"; exit 0; }

    clone() { # <url> <path>
      [ -e "$dest/$2" ] && return 0
      echo "clone $2"
      rm -rf "$dest/$2.part"
      git clone --quiet --depth 1 "$1" "$dest/$2.part"
      mv "$dest/$2.part" "$dest/$2"
    }

    fetch() { # <url> <path> [filter command...]
      local url=$1 path=$2
      shift 2
      [ -e "$dest/$path" ] && return 0
      echo "fetch $path"
      mkdir -p "$(dirname "$dest/$path")"
      if [ $# -eq 0 ]; then
        curl -fsSL --retry 3 -o "$dest/$path.part" "$url"
      else
        curl -fsSL --retry 3 "$url" | "$@" >"$dest/$path.part"
      fi
      mv "$dest/$path.part" "$dest/$path"
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
      fetch "$cdn/kiterunner/$kite.kite.tar.gz" "assetnote/kiterunner/$kite.kite" tar -xzO "$kite.kite"
    done
  '';
}
