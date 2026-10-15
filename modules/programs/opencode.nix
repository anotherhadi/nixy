# Opencode with local Ollama models
# Switch model in a session with /models
{
  aspects,
  config,
  lib,
  ...
}: let
  c = config.theme.withHashtag;
  # key = [dark light] base16 slots, same mapping as stylix's opencode target
  themeSlots = {
    accent = ["base0F" "base07"];
    background = ["base00" "base06"];
    backgroundElement = ["base01" "base04"];
    backgroundPanel = ["base01" "base05"];
    border = ["base02" "base03"];
    borderActive = ["base03" "base02"];
    borderSubtle = ["base02" "base03"];
    diffAdded = ["base0B" "base0B"];
    diffAddedBg = ["base01" "base05"];
    diffAddedLineNumberBg = ["base01" "base05"];
    diffContext = ["base03" "base03"];
    diffContextBg = ["base01" "base05"];
    diffHighlightAdded = ["base0B" "base0B"];
    diffHighlightRemoved = ["base08" "base08"];
    diffHunkHeader = ["base03" "base03"];
    diffLineNumber = ["base03" "base04"];
    diffRemoved = ["base08" "base08"];
    diffRemovedBg = ["base01" "base05"];
    diffRemovedLineNumberBg = ["base01" "base05"];
    error = ["base08" "base08"];
    info = ["base0C" "base0F"];
    markdownBlockQuote = ["base03" "base01"];
    markdownCode = ["base0B" "base0B"];
    markdownCodeBlock = ["base01" "base00"];
    markdownEmph = ["base0A" "base09"];
    markdownHeading = ["base0E" "base0F"];
    markdownHorizontalRule = ["base04" "base03"];
    markdownImage = ["base0D" "base0D"];
    markdownImageText = ["base0C" "base07"];
    markdownLink = ["base0D" "base0D"];
    markdownLinkText = ["base0C" "base07"];
    markdownListEnumeration = ["base0C" "base07"];
    markdownListItem = ["base0D" "base0F"];
    markdownStrong = ["base09" "base0A"];
    markdownText = ["base05" "base00"];
    primary = ["base0D" "base0F"];
    secondary = ["base0E" "base0D"];
    success = ["base0B" "base0B"];
    syntaxComment = ["base04" "base03"];
    syntaxFunction = ["base0D" "base0C"];
    syntaxKeyword = ["base0E" "base0D"];
    syntaxNumber = ["base09" "base0E"];
    syntaxOperator = ["base0C" "base0D"];
    syntaxPunctuation = ["base05" "base00"];
    syntaxString = ["base0B" "base0B"];
    syntaxType = ["base0A" "base07"];
    syntaxVariable = ["base07" "base07"];
    text = ["base05" "base00"];
    textMuted = ["base04" "base01"];
    warning = ["base0A" "base0A"];
  };
in {
  flake.modules.nixos.opencode = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        json = (pkgs.formats.json {}).generate;
      in {
        packages = [pkgs.opencode];

        xdg.config.files."opencode/opencode.json" = {
          generator = json "opencode.json";
          value = {
            "$schema" = "https://opencode.ai/config.json";
            provider.ollama = {
              npm = "@ai-sdk/openai-compatible";
              name = "Ollama (local)";
              options.baseURL = "http://localhost:11434/v1";
              models = {
                "qwen3.5:35b-a3b".name = "Qwen3.5 35B-A3B";
                "huihui_ai/qwen3.5-abliterated:35b-a3b".name = "Qwen3.5 35B-A3B (abliterated)";
                "qwen3.5:9b".name = "Qwen3.5 9B (fast)";
              };
            };
            model = "ollama/qwen3.5:35b-a3b";
          };
        };

        xdg.config.files."opencode/tui.json" = {
          generator = json "tui.json";
          value = {
            "$schema" = "https://opencode.ai/tui.json";
            theme = "nixy";
          };
        };

        xdg.config.files."opencode/themes/nixy.json" = {
          generator = json "nixy.json";
          value = {
            "$schema" = "https://opencode.ai/theme.json";
            theme =
              lib.mapAttrs (_: slots: {
                dark = c.${builtins.elemAt slots 0};
                light = c.${builtins.elemAt slots 1};
              })
              themeSlots;
          };
        };
      })
    ];
  };
}
