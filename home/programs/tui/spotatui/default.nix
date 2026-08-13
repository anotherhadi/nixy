# Spotatui is a terminal user interface for Spotify, written in Rust. It allows you to control your Spotify playback and manage your playlists directly from the terminal.
{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  rgb = base: "${c."${base}-rgb-r"}, ${c."${base}-rgb-g"}, ${c."${base}-rgb-b"}";
in {
  home.packages = with pkgs; [
    spotatui
  ];

  home.file.".config/spotatui/config.yml".text = ''
    keybindings:
      back: q
      next_page: ctrl-d
      previous_page: ctrl-u
      jump_to_start: ctrl-a
      jump_to_end: ctrl-e
      jump_to_album: a
      jump_to_artist_album: A
      jump_to_context: o
      manage_devices: d
      decrease_volume: '-'
      increase_volume: +
      toggle_playback: space
      seek_backwards: <
      seek_forwards: '>'
      next_track: n
      previous_track: p
      force_previous_track: P
      help: '?'
      shuffle: ctrl-s
      repeat: ctrl-r
      search: /
      submit: enter
      copy_song_url: c
      copy_album_url: C
      audio_analysis: v
      lyrics_view: B
      cover_art_view: G
      add_item_to_queue: z
      show_queue: Q
      open_settings: alt-,
      save_settings: alt-s
      listening_party: ctrl-p
      like_track: F
    behavior:
      seek_milliseconds: 5000
      volume_increment: 10
      volume_percent: 100
      tick_rate_milliseconds: 16
      enable_text_emphasis: true
      show_loading_indicator: true
      enforce_wide_search_bar: true
      enable_global_song_count: false
      disable_mouse_inputs: false
      enable_discord_rpc: false
      discord_rpc_client_id: null
      enable_announcements: false
      announcement_feed_url: null
      seen_announcement_ids:
      - 2026-05-19-sonos-help-wanted
      - 2026-02-27-major-refactor-complete
      shuffle_enabled: false
      liked_icon: ♥
      shuffle_icon: 🔀
      repeat_track_icon: 🔂
      repeat_context_icon: 🔁
      playing_icon: ▶
      paused_icon: ⏸
      set_window_title: true
      visualizer_style: Equalizer
      dismissed_announcements: []
      relay_server_url: wss://spotatui-party.spotatui.workers.dev/ws
      stop_after_current_track: false
      sidebar_width_percent: 20
      playbar_height_rows: 6
      library_height_percent: 30
      startup_behavior: continue
      disable_auto_update: true
      auto_update_delay: '0'
      keepawake_enabled: true
    theme:
      preset: Custom
      active: ${rgb "base0D"}
      banner: ${rgb "base0C"}
      error_border: ${rgb "base08"}
      error_text: ${rgb "base08"}
      hint: ${rgb "base0A"}
      hovered: ${rgb "base0E"}
      inactive: ${rgb "base03"}
      playbar_background: Reset
      playbar_progress: ${rgb "base0D"}
      playbar_progress_text: ${rgb "base05"}
      playbar_text: Reset
      selected: ${rgb "base0D"}
      text: Reset
      background: Reset
      header: Reset
      highlighted_lyrics: ${rgb "base0B"}
  '';
}
