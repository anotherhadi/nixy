# Opencode with local Ollama models
# Switch model in a session with /models
{
  programs.opencode = {
    enable = true;
    settings = {
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
}
