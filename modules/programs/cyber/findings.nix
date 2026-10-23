# mdtable: table of the markdown frontmatters of a directory
# findings: views of the bug bounty findings of the current directory
{
  aspects,
  config,
  ...
}: let
  inherit (config) theme;
  c = theme.withHashtag;
in {
  flake.modules.nixos.findings = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        lib,
        pkgs,
        ...
      }: let
        # gum >= 2 truncates cells ANSI-aware (colored values), but its interactive table
        # renders blank rows since 2.0.0. TODO: drop the patch once it is merged/released
        # https://github.com/charmbracelet/gum/issues/1126
        gum = pkgs.unstable.gum.overrideAttrs (old: {
          patches =
            (old.patches or [])
            ++ [
              (pkgs.fetchpatch {
                name = "gum-table-blank-rows.patch"; # https://github.com/charmbracelet/gum/pull/1137
                url = "https://github.com/charmbracelet/gum/commit/15aacdbd0557d3537e9f6b89d576c679e6cd0694.patch";
                hash = "sha256-AD8Z9T74OKWXhmOoy1A4O+bwGraBuLUJ4eAEyuUZaBo=";
              })
            ];
        });

        # SGR parameters of a theme color, for the cell values
        fg = base: "38;2;${lib.concatMapStringsSep ";" toString theme.rgb.${base}}";
        bold = base: "1;${fg base}";
        dim = fg "base03";

        # Frontmatter value
        valueColors = {
          # severity
          critical = bold "base08";
          high = fg "base08";
          medium = fg "base09";
          low = fg "base0A";
          info = dim;
          none = dim;
          # status
          accepted = fg "base0B";
          resolved = fg "base0B";
          fixed = fg "base0B";
          paid = fg "base0B";
          new = fg "base0D";
          triaged = fg "base0D";
          pending = fg "base0D";
          under-review = fg "base0D";
          draft = fg "base0E";
          to_send = fg "base0E";
          not-sent = fg "base0E";
          dup = dim;
          duplicate = dim;
          informative = dim;
          "n/a" = dim;
          not-applicable = dim;
          out-of-scope = dim;
          rejected = dim;
          closed = dim;
          wontfix = dim;
          # bounty
          waiting = fg "base0A";
        };

        mdtable = pkgs.writeShellApplication {
          name = "mdtable";
          runtimeInputs = with pkgs; [
            coreutils
            gum
            jq
            ripgrep
            yq-go
          ];
          text = ''
            usage() {
              cat >&2 <<'EOF'
            Usage: mdtable [-d DIR] [-w FILTER] [-s KEY] [-r] [-t KEY] [-p] [COLUMN...]
            Table of the markdown frontmatters found in DIR, recursively (_templates excluded)
              -d DIR     root directory (default: .)
              -w FILTER  jq boolean expression on the frontmatter, e.g. '.type == "finding"'
              -s KEY     sort by this key (default: file)
              -r         reverse the sort
              -t KEY     print the sum of the numeric values of KEY
              -p         print the table, instead of picking a note to open
              COLUMN     frontmatter keys, or file (note name), path, mtime
                         (default: file and every key found)
            EOF
              exit 1
            }

            dir=. filter=true sort=file reverse=false total="" print=false
            while getopts "d:w:s:rt:ph" opt; do
              case "$opt" in
                d) dir=$OPTARG ;;
                w) filter=$OPTARG ;;
                s) sort=$OPTARG ;;
                r) reverse=true ;;
                t) total=$OPTARG ;;
                p) print=true ;;
                *) usage ;;
              esac
            done
            shift $((OPTIND - 1))
            [[ -t 1 ]] || print=true # piped: nothing to pick from
            cd "$dir"

            notes() {
              { rg -0 -lU '\A---\r?\n' -g '*.md' -g '!_templates' || true; } |
                while IFS= read -r -d "" f; do
                  MTIME=$(stat -c %Y -- "$f") yq -f extract -o json -I0 \
                    '(. // {}) + {"path": filename, "mtime": env(MTIME)}' "$f" 2>/dev/null ||
                    echo "mdtable: unreadable frontmatter: $f" >&2
                done
            }

            # Matching notes, sorted, with their name in .file
            load() {
              notes | jq -s --arg sort "$sort" --argjson reverse "$reverse" "
                map(. + {file: (.path | split(\"/\") | last | sub(\"\\\\.md$\"; \"\"))})
                | map(select($filter))
                | sort_by(.[\$sort])
                | if \$reverse then reverse else . end"
            }

            # CSV for gum: header, then a row per note, values colored
            to_csv() {
              jq -r --argjson cols "$(jq -cn '$ARGS.positional' --args "$@")" \
                --argjson pick "$([[ $print == true ]] && echo false || echo true)" \
                --argjson colors ${lib.escapeShellArg (builtins.toJSON valueColors)} '
                def cell:
                  if type == "array" then map(tostring) | join(", ")
                  elif type == "object" then tojson
                  elif . == null then ""
                  else tostring end;
                def paint:
                  ($colors[ascii_downcase] // null) as $c
                  | if $c then "\u001b[\($c)m\(.)\u001b[22;39m" else . end;
                . as $notes
                | (if $cols != [] then $cols
                   else ["file"] + ([$notes[] | keys_unsorted[] | select(IN("file", "path", "mtime") | not)]
                     | reduce .[] as $k ([]; if index([$k]) then . else . + [$k] end))
                   end) as $cols
                # The file column is the one returned by the picker
                | (if $pick and ($cols | index(["file"]) | not) then ["file"] + $cols else $cols end) as $cols
                | ($cols | join(",")),
                  ($notes[] as $n | $cols | map(
                    if . == "mtime" then $n.mtime | localtime | strftime("%Y-%m-%d %H:%M")
                    elif . == "file" or . == "path" then $n[.] | cell
                    else $n[.] | cell | paint end
                  ) | @csv)'
            }

            show_total() {
              [[ -n $total ]] || return 0
              jq -r --arg k "$total" '"Total \($k): \(map(.[$k] | numbers) | add // 0)"' <<<"$1" |
                gum style --foreground '${c.base0B}' --bold
            }

            style=(
              --border rounded
              --border.foreground '${c.base03}'
              --header.foreground '${c.base0D}'
              --selected.foreground '${c.base05}'
              --selected.background '${c.base02}'
            )

            while :; do
              rows=$(load)
              if [[ $(jq length <<<"$rows") == 0 ]]; then
                echo "mdtable: no matching note" >&2
                exit 0
              fi
              csv=$(to_csv "$@" <<<"$rows")
              show_total "$rows"

              if [[ $print == true ]]; then
                gum table --print "''${style[@]}" <<<"$csv"
                exit 0
              fi

              IFS=, read -ra header <<<"''${csv%%$'\n'*}"
              for i in "''${!header[@]}"; do
                [[ ''${header[i]} == file ]] && col=$((i + 1))
              done

              # Fit the table: higher than the terminal, gum renders no row at all
              read -r lines _ < <(stty size </dev/tty)
              height=$(($(jq length <<<"$rows") + 2))
              ((height <= lines - 3)) || height=$((lines - 3))

              name=$(gum table "''${style[@]}" --height "$height" --return-column "$col" <<<"$csv") || exit 0
              [[ -n $name ]] || exit 0
              path=$(jq -r --arg n "$name" 'first(.[] | select(.file == $n) | .path)' <<<"$rows")
              "''${EDITOR:-nvim}" "$path"
            done
          '';
        };

        findings = pkgs.writeShellApplication {
          name = "findings";
          runtimeInputs = [mdtable pkgs.jq];
          text = ''
            usage() {
              cat >&2 <<'EOF'
            Usage: findings [VIEW] [mdtable options]
            Findings of the current directory and its subdirectories (type: finding)
              last           latest edited (default)
              all            every column, latest edited first
              todo           not sent yet, oldest first
              pending        waiting for the triage, oldest first
              unpaid         accepted, bounty not received yet, oldest first
              paid           bounty received, with the total
              program NAME   findings of one program, latest first
            Options (see mdtable -h): -p to print, -s KEY / -r to sort, -w to filter more
            EOF
              exit 1
            }

            finding='.type == "finding"'
            # Template default (0), empty, or "waiting"
            unpaid='((.bounty // 0) | . == 0 or . == "" or . == "waiting")'

            view=''${1:-last}
            [[ $# -gt 0 ]] && shift
            case "$view" in
              last)
                mdtable -w "$finding" -s mtime -r "$@" \
                  file vuln severity status ;;
              all)
                mdtable -w "$finding" -s mtime -r "$@" \
                  file vuln severity status program date cvss bounty ;;
              todo)
                mdtable -w "$finding and (.status | IN(\"to_send\", \"not-sent\", \"draft\"))" -s date "$@" \
                  file program vuln severity date ;;
              pending)
                mdtable -w "$finding and (.status | IN(\"new\", \"triaged\", \"under-review\"))" -s date "$@" \
                  file program vuln severity status date ;;
              unpaid)
                mdtable -w "$finding and .status == \"accepted\" and $unpaid" -s date "$@" \
                  file program severity cvss date bounty ;;
              paid)
                mdtable -w "$finding and (.bounty | type == \"number\" and . > 0)" -s date -r -t bounty "$@" \
                  file program vuln severity date bounty ;;
              program)
                [[ $# -gt 0 ]] || usage
                program=$(jq -n --arg p "$1" '$p') # JSON string, quoted for the filter
                shift
                mdtable -w "$finding and .program == $program" -s date -r "$@" \
                  file vuln severity status date bounty ;;
              *) usage ;;
            esac
          '';
        };
      in {
        packages = [mdtable findings];
      })
    ];
  };
}
