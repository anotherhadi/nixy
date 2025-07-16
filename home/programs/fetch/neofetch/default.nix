# Legacy
{pkgs, ...}: {
  home.packages = with pkgs; [neofetch];

  xdg.configFile."neofetch/ascii.txt".text = ''
    ''${c6}
    ⡏⠉⠉⠉⠉⠉⠉⠋⠉⠉⠉⠉⠉⠉⠋⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠙⠉⠉⠉⢹
    ⡇⢸⣿⡟⠛⢿⣷⠀⢸⣿⡟⠛⢿⣷⡄⢸⣿⡇⠀⢸⣿⡇⢸⣿⡇⠀⢸⣿⡇⢸
    ⡇⢸⣿⣧⣤⣾⠿⠀⢸⣿⣇⣀⣸⡿⠃⢸⣿⡇⠀⢸⣿⡇⢸⣿⣇⣀⣸⣿⡇⢸
    ⡇⢸⣿⡏⠉⢹⣿⡆⢸⣿⡟⠛⢻⣷⡄⢸⣿⡇⠀⢸⣿⡇⢸⣿⡏⠉⢹⣿⡇⢸
    ⡇⢸⣿⣧⣤⣼⡿⠃⢸⣿⡇⠀⢸⣿⡇⠸⣿⣧⣤⣼⡿⠁⢸⣿⡇⠀⢸⣿⡇⢸
    ⣇⣀⣀⣀⣀⣀⣀⣄⣀⣀⣀⣀⣀⣀⣀⣠⣀⡈⠉⣁⣀⣄⣀⣀⣀⣠⣀⣀⣀⣸
    ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷
    ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇
    ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
    ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
    ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
    ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
    ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
    ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕
    ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
    ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
    ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
    ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
    ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣
  '';

  xdg.configFile."neofetch/config.conf".text = ''
    # From: https://github.com/Chick2D/neofetch-themes/
    # Made by https://github.com/Dan1jel

    print_info() {
        prin "\n"
        info "\n \n OS" distro
        info "\n \n Host" model
        info "\n \n Kernel" kernel
        info "\n \n Uptime" uptime
        info "\n \n Packages" packages
        info "\n \n Shell" shell
        info "\n \n Resolution" resolution
        info "\n \n DE" de
        info "\n \n WM" wm
        info "\n \n WM Theme" wm_theme
        info "\n \n Theme" theme
        info "\n \n Icons" icons
        info "\n \n Terminal" term
        info "\n \n Terminal Font" term_font
        info "\n \n CPU" cpu
        info "\n \n GPU" gpu
        info "\n \n Memory" memory
        info "\n \n Disk" disk
        info "\n \n Battery" battery
        info "\n \n Font" font
        info "\n \n Song" song
        [[ "$player" ]] && prin "\n \n Music Player" "$player"
        info "\n \n Local IP" local_ip
        prin "\n"

        # prin "\n \n    ''${cl0}──''${cl1}────''${cl2}────''${cl3}────''${cl4}────''${cl5}────''${cl6}────''${cl7}──"
        prin "\n \n \n \n \n \n ''${cl0}⬤ \n \n ''${cl1}⬤ \n \n ''${cl2}⬤ \n \n ''${cl3}⬤ \n \n ''${cl4}⬤ \n \n ''${cl5}⬤ \n \n ''${cl6}⬤ \n \n ''${cl7}⬤"
    }

    reset="\033[0m"
    gray="\033[1;90m"
    red="\033[1;31m"
    green="\033[1;32m"
    yellow="\033[1;33m"
    blue="\033[1;34m"
    magenta="\033[1;35m"
    cyan="\033[1;36m"
    white="\033[1;37m"

    cl0="''${gray}"
    cl1="''${red}"
    cl2="''${green}"
    cl3="''${yellow}"
    cl4="''${blue}"
    cl5="''${magenta}"
    cl6="''${cyan}"
    cl7="''${white}"

    title_fqdn="off"
    kernel_shorthand="on"
    distro_shorthand="off"
    os_arch="off"
    uptime_shorthand="on"
    memory_percent="off"
    memory_unit="mib"
    package_managers="on"
    shell_path="off"
    shell_version="on"
    speed_type="bios_limit"
    speed_shorthand="off"
    cpu_brand="on"
    cpu_speed="on"
    cpu_cores="logical"
    cpu_temp="off"
    gpu_brand="on"
    gpu_type="all"
    refresh_rate="off"
    gtk_shorthand="off"
    gtk2="on"
    gtk3="on"
    de_version="on"
    disk_show=('/storage/emulated' '/' '/server')
    disk_subtitle="none"
    disk_percent="on"
    music_player="auto"
    song_format="%artist% - %album% - %title%"
    song_shorthand="off"
    mpc_args=()
    bold="on"
    underline_enabled="on"
    underline_char="-"
    separator=":"
    block_range=(0 15)
    color_blocks="on"
    block_width=3
    block_height=1
    col_offset="auto"
    bar_char_elapsed="-"
    bar_char_total="="
    bar_border="on"
    bar_length=15
    bar_color_elapsed="distro"
    bar_color_total="distro"
    cpu_display="off"
    memory_display="off"
    battery_display="off"
    disk_display="off"
    image_backend="ascii"
    image_source="$HOME/.config/neofetch/ascii.txt"
    ascii_distro="auto"
    ascii_colors=(distro)
    ascii_bold="on"
    image_loop="off"
    thumbnail_dir="''${XDG_CACHE_HOME:-''${HOME}/.cache}/thumbnails/neofetch"
    crop_mode="normal"
    crop_offset="center"
    image_size="auto"
    gap=2
    yoffset=0
    xoffset=0
    background_color=
    stdout="off"
  '';
}
