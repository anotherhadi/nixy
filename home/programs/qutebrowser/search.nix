{...}: {
  programs.qutebrowser.searchEngines = rec {
    startpage = "https://www.startpage.com/sp/search?q={}";

    mynixos = "https://mynixos.com/search?q={}";
    duckduckgo = "https://duckduckgo.com/?q={}";
    google = "https://google.com/search?hl=en&q={}";
    yandex = "https://yandex.com/search/?text={}";
    bing = "https://bing.com/search?q={}";
    youtube = "https://youtube.com/results?search_query={}";
    google-images = "https://google.com/search?hl=en&tbm=isch&q={}";

    # AI
    chatgpt = "https://chatgpt.com/?q={}";
    claude = "https://claude.ai/new?q={}";
    gemini = "https://gemini.google.com/app?q={}";

    # Maps
    amap = "https://maps.apple.com/?q={}";
    gmap = "https://www.google.com/maps/search/{}";

    # shortcuts
    g = google;
    n = mynixos;
    gpt = chatgpt;
    gem = gemini;
    cla = claude;
    DEFAULT = startpage;
  };
}
