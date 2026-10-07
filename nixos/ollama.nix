# Ollama: local LLM server with CUDA acceleration
{
  config,
  lib,
  pkgs,
  ...
}: let
  impermanence = config.var.impermanenceEnabled or false;
  modelsDir = "/persist/ollama/models";
in {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    user = "ollama";

    models = lib.mkIf impermanence modelsDir;

    loadModels = [
      "qwen3.5:35b-a3b"
      "huihui_ai/qwen3.5-abliterated:35b-a3b"
      "qwen3.5:9b"
    ];

    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32768"; # Default context is too small for opencode tool calls
      OLLAMA_MAX_LOADED_MODELS = "1"; # Never keep two big models in memory
      OLLAMA_KEEP_ALIVE = "30m"; # Reloading the 35B takes ~15s, keep it in memory between messages
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };

  systemd.tmpfiles.rules = lib.mkIf impermanence [
    "d /persist/ollama 0750 ollama ollama -"
    "d ${modelsDir} 0750 ollama ollama -"
  ];
}
