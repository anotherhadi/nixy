# signal-notify: send a Signal message through the homelab's signal-cli-rest-api
# Usage: signal-notify [-r h]... MESSAGE
{aspects, ...}: {
  flake.modules.nixos.signal-notify = {
    config,
    lib,
    pkgs,
    ...
  }: let
    username = config.nixy.username;
    url = "https://signal.hadi.icu/v2/send";

    # Each recipient is a top-level key of the host's sops file holding its number
    signalRecipients = lib.filter (n: builtins.elem n config.nixy.secrets.available) [
      "h"
    ];

    required = [
      "signal_sender_number"
      "cloudflare-mtls-cert"
      "cloudflare-mtls-key"
    ];
    enabled =
      lib.all (k: builtins.elem k config.nixy.secrets.available) required
      && signalRecipients != [];

    userSecret = {
      owner = username;
      mode = "0400";
    };
    secret = name: config.sops.secrets.${name}.path;

    signal-notify = pkgs.writeShellApplication {
      name = "signal-notify";
      runtimeInputs = with pkgs; [
        curl
        jq
      ];
      text = ''
        usage() {
          echo "Usage: signal-notify [-r ${lib.concatStringsSep "|" signalRecipients}]... MESSAGE" >&2
          exit 1
        }

        numbers=()
        while getopts "r:h" opt; do
          case "$opt" in
            r)
              case "$OPTARG" in
                ${lib.concatMapStrings (n: ''
            ${n}) numbers+=("$(<${secret "signal-${n}"})") ;;
          '')
          signalRecipients}
                *) echo "Unknown recipient: $OPTARG" >&2; usage ;;
              esac
              ;;
            *) usage ;;
          esac
        done
        shift $((OPTIND - 1))
        [ $# -gt 0 ] || usage
        [ ''${#numbers[@]} -gt 0 ] || numbers=("$(<${secret "signal-${lib.head signalRecipients}"})")

        jq -n \
          --arg number "$(<${secret "signal-sender-number"})" \
          --arg message "$*" \
          '{number: $number, recipients: $ARGS.positional, message: $message}' \
          --args "''${numbers[@]}" |
          curl -fsS -X POST ${url} \
            --cert ${secret "cloudflare-mtls-cert"} \
            --key ${secret "cloudflare-mtls-key"} \
            -H "Content-Type: application/json" \
            --data @- >/dev/null
      '';
    };
  in {
    imports = [aspects.secrets];

    # Only on hosts whose sops file has the sender, a recipient and the mTLS client cert
    config = lib.mkIf enabled {
      sops.secrets =
        {
          signal-sender-number = userSecret // {key = "signal_sender_number";};
          # PEM client certificate and key of the Cloudflare mTLS rule on *.hadi.icu
          cloudflare-mtls-cert = userSecret;
          cloudflare-mtls-key = userSecret;
        }
        // lib.listToAttrs (map (n: lib.nameValuePair "signal-${n}" (userSecret // {key = n;})) signalRecipients);

      environment.systemPackages = [signal-notify];
    };
  };
}
