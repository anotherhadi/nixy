# NVF config en flake réutilisable

**Date:** 2026-07-29
**Statut:** Approuvé (design)

## Objectif

Permettre à n'importe qui de réutiliser la configuration NVF (Neovim via
[nvf](https://github.com/notashelf/nvf)) de ce dépôt, de deux façons :

1. **`nix run`** — lancer le nvim standalone sans home-manager.
2. **Module home-manager** — importer un module dans sa propre config, qui
   s'adapte automatiquement à *son* thème stylix.

Le tout sans traîner les inputs lourds du monorepo (nixarr, blog,
awesome-wallpapers, etc.), et en supportant Linux **et** macOS.

## État actuel

- `home/programs/nvf/flake.nix` n'est **pas** un vrai flake : c'est une fonction
  `{ inputs, pkgs, system, ... }` fusionnée dans les outputs du flake racine via
  `import ./home/programs/nvf/flake.nix args`.
- Elle expose déjà `packages.<system>.nvim`, `apps.<system>.nvim` et
  `homeManagerModules.nvim`, mais :
  - uniquement pour `x86_64-linux` (system codé en dur) ;
  - `homeManagerModules.nvim` importe `default.nix`, qui **exige `inputs`**
    (via `inputs.nvf...`) — un tiers devrait le fournir lui-même ;
  - un tiers qui consomme le flake racine tire **tous** les inputs lourds.
- Les hosts consomment nvf en important **directement le dossier**
  (`imports = [ ../../home/programs/nvf ]` → `default.nix`), `inputs` venant des
  `extraSpecialArgs` du monorepo. `homeManagerModules.nvim` n'est donc **pas**
  utilisé en interne aujourd'hui.
- `default.nix` référence `config.lib.stylix.colors` **sans garde** → un
  consommateur sans stylix aurait une erreur d'évaluation.

## Design

### 1. `home/programs/nvf/flake.nix` → vrai flake

Remplace la fonction actuelle. Inputs minimaux, outputs multi-systèmes.

- `inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05"` (stable)
- `inputs.nvf.url = "github:notashelf/nvf"`
- Systèmes : `x86_64-linux`, `aarch64-linux`, `aarch64-darwin`, `x86_64-darwin`
  via un helper `forAllSystems` (`nixpkgs.lib.genAttrs`).
- Liste de modules partagée : `options.nix`, `languages.nix`, `picker.nix`,
  `snacks.nix`, `keymaps.nix`, `utils.nix`, `mini.nix`.

Outputs :

- `packages.<sys>.nvim` (+ `.default`) = `(nvf.lib.neovimConfiguration { inherit pkgs modules; }).neovim`
- `apps.<sys>.nvim` (+ `.default`) pointant vers `${nvim}/bin/nvim`
- `homeManagerModules.nvim` (+ `.default`) :
  `{ imports = [ nvf.homeManagerModules.default ./default.nix ]; }`
  — `nvf` capturé depuis les inputs **du flake**, donc le tiers n'a rien à fournir.
- `formatter.<sys>` = `pkgs.alejandra`

### 2. `home/programs/nvf/default.nix` — découplé + garde stylix

- Signature : `{ config, lib, ... }` — plus de `inputs`.
- Retirer `imports = [ inputs.nvf.homeManagerModules.default ]` (désormais dans
  le wrapper `homeManagerModules.nvim` du flake).
- Rendre l'override stylix conditionnel :

  ```nix
  vim.luaConfigRC = lib.mkIf (config ? stylix && config.stylix.enable) {
    hl-overrides = let c = config.lib.stylix.colors; in '' ... '';
  };
  ```

  - Avec stylix → nvim prend la palette du consommateur.
  - Sans stylix → nvim marche, thème natif nvf.

### 3. Flake racine (`flake.nix`)

- Ajouter l'input :

  ```nix
  nvf-config = {
    url = "path:./home/programs/nvf";
    inputs.nixpkgs.follows = "nixpkgs-stable";
    inputs.nvf.follows = "nvf";
  };
  ```

- Retirer la ligne `(import ./home/programs/nvf/flake.nix args)` du `merge`.
- Ré-exposer, pour garder `nix run .#nvim` depuis la racine :

  ```nix
  packages.${system}.nvim = inputs.nvf-config.packages.${system}.nvim;
  apps.${system}.nvim     = inputs.nvf-config.apps.${system}.nvim;
  ```

### 4. Hosts

`hosts/laptop/home.nix`, `hosts/work/home.nix`, `hosts/server/home.nix` :

```nix
# avant
imports = [ ../../home/programs/nvf ];
# après
imports = [ inputs.nvf-config.homeManagerModules.default ];
```

Toi et les tiers utilisez ainsi exactement le même module.

## Locks

Deux `flake.lock` distincts : racine + `home/programs/nvf/flake.lock`.

| Contexte | Lock qui fait foi |
|----------|-------------------|
| Toi, via le monorepo (`follows`) | Lock **racine** ; le lock du sous-flake est ignoré. |
| Tiers, `github:.../nixos?dir=home/programs/nvf` | Lock du **sous-flake**. |
| `nix run ./home/programs/nvf#nvim` | Lock du sous-flake. |

**Friction connue :** le `path:` input est épinglé dans le lock racine. Après
édition de la config nvim, faire `nix flake update nvf-config` (ou
`--update-input nvf-config`) pour que le monorepo reprenne les changements.

## Décisions clés (YAGNI)

- **Flake dédié dans le monorepo** (pas dépôt séparé) — source unique, pas de
  synchro à gérer.
- **Garde stylix optionnelle** plutôt qu'exigence dure — coût nul, évite un
  footgun pour les tiers non-stylixés.
- **Multi-système** — trivial via `genAttrs`, permet l'usage sur macOS.

## Vérification

- `nix flake check ./home/programs/nvf`
- `nix run ./home/programs/nvf#nvim` (lance nvim standalone)
- `nix flake check` à la racine
- Rebuild d'un host (ex. laptop) sans régression nvim, thème stylix conservé.
