# Groups

Groups are curated sets of packages exposed as flake outputs. Each group has two forms:

- **`homeManagerModules.<group>`** — full home-manager module (packages + files + systemd units)
- **`packages.<group>`** — standalone environment for `nix shell` (packages only)

## Available groups

- dev (go, bun, air, ...)
- cybersecurity (nmap, john, dirb, ffuf, ...)

For the Cybersecurity group, the home-manager module also sets up:

- `~/Cyber/wordlists/` with SecLists, fuzz4bounty, and hashcat rules
- `~/Cyber/tmp/` as a temporary workspace

## Use in another flake

Add this repo as an input:

```nix
inputs.nixy.url = "github:anotherhadi/nixy";
```

Import the home-manager module in your home configuration:

```nix
{ inputs, ... }: {
  imports = [
    inputs.nixy.homeManagerModules.cybersecurity
    # inputs.nixy.homeManagerModules.dev
  ];
}
```

## Quick shell without installing

```sh
nix shell github:anotherhadi/nixy#cybersecurity
nix shell github:anotherhadi/nixy#dev
```

This drops you into a shell with all tools in `PATH`. No home-manager required, no wordlists or systemd units.
