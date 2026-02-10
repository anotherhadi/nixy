# Thunar is a file explorer
{
  pkgs,
  config,
  lib,
  ...
}: let
  user = config.var.username;
in {
  # ctrl + m to toggle the menubar
  home.packages = with pkgs; [
    thunar
    xfconf
    tumbler
    thunar-archive-plugin
    thunar-volman
    thunar-media-tags-plugin
    p7zip
    xarchiver
    papirus-icon-theme
    material-icons
    material-design-icons
    material-symbols
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # bookmarks for the side pane
    gtk3.bookmarks = [
      "file:///home/${user}/Downloads Downloads"
      "file:///home/${user}/Pictures Pictures"
      "file:///home/${user}/.config/nixos NixOS"
      "file:///home/${user}/dev Development"
    ];
  };

  qt.enable = true;

  home.sessionVariables = {
    XDG_ICON_DIR = "${pkgs.papirus-icon-theme}/share/icons/Papirus";
    QS_ICON_THEME = "Papirus";
    QT_STYLE_OVERRIDE = lib.mkForce "Fusion";
  };

  home.file.".config/xarchiver/xarchiverrc".text = ''
    [xarchiver]
    preferred_format=0
    prefer_unzip=true
    confirm_deletion=true
    sort_filename_content=false
    advanced_isearch=true
    auto_expand=true
    store_output=false
    icon_size=2
    show_archive_comment=false
    show_sidebar=true
    show_location_bar=true
    show_toolbar=true
    preferred_custom_cmd=
    preferred_temp_dir=/tmp
    preferred_extract_dir=./
    allow_sub_dir=0
    ensure_directory=true
    overwrite=false
    full_path=2
    touch=false
    fresh=false
    update=false
    store_path=false
    updadd=true
    freshen=false
    recurse=true
    solid_archive=false
    remove_files=false
  '';

  home.file.".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml" = {
    text = ''
      <?xml version="1.1" encoding="UTF-8"?>

      <channel name="thunar" version="1.0">
        <property name="last-view" type="string" value="ThunarIconView"/>
        <property name="last-icon-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_100_PERCENT"/>
        <property name="last-window-maximized" type="bool" value="true"/>
        <property name="last-separator-position" type="int" value="230"/>
        <property name="last-statusbar-visible" type="bool" value="false"/>
        <property name="last-menubar-visible" type="bool" value="false"/>
        <property name="misc-single-click" type="bool" value="false"/>
        <property name="shortcuts-icon-emblems" type="bool" value="true"/>
        <property name="tree-icon-emblems" type="bool" value="true"/>
        <property name="misc-file-size-binary" type="bool" value="false"/>
        <property name="misc-thumbnail-draw-frames" type="bool" value="true"/>
        <property name="misc-text-beside-icons" type="bool" value="false"/>
        <property name="misc-change-window-icon" type="bool" value="false"/>
        <property name="hidden-bookmarks" type="array">
          <value type="string" value="computer:///"/>
          <value type="string" value="recent:///"/>
          <value type="string" value="network:///"/>
        </property>
        <property name="hidden-devices" type="array">
          <value type="string" value="52FEA905FEA8E309"/>
        </property>
        <property name="last-toolbar-item-order" type="string" value="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17"/>
        <property name="last-toolbar-visible-buttons" type="string" value="0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0"/>
        <property name="last-location-bar" type="string" value="ThunarLocationButtons"/>
        <property name="last-show-hidden" type="bool" value="false"/>
        <property name="last-details-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_38_PERCENT"/>
        <property name="last-details-view-column-widths" type="string" value="50,50,118,111,50,50,50,50,993,50,50,84,50,151"/>
        <property name="last-toolbar-items" type="string" value="menu:1,undo:1,back:1,forward:1,open-parent:0,open-home:0,redo:0,zoom-in:0,zoom-out:0,zoom-reset:0,location-bar:1,view-switcher:1,search:1,view-as-icons:0,view-as-detailed-list:0,view-as-compact-list:0,toggle-split-view:0,reload:0,new-tab:0,new-window:0,uca-action-1700000000000001:0"/>
        <property name="last-side-pane" type="string" value="THUNAR_SIDEPANE_TYPE_SHORTCUTS"/>
        <property name="last-image-preview-visible" type="bool" value="false"/>
        <property name="misc-use-csd" type="bool" value="true"/>
        <property name="default-view" type="string" value="ThunarIconView"/>
        <property name="misc-thumbnail-max-file-size" type="uint64" value="1073741824"/>
        <property name="misc-symbolic-icons-in-toolbar" type="bool" value="true"/>
        <property name="misc-date-style" type="string" value="THUNAR_DATE_STYLE_SIMPLE"/>
        <property name="shortcuts-icon-size" type="string" value="THUNAR_ICON_SIZE_16"/>
        <property name="tree-icon-size" type="string" value="THUNAR_ICON_SIZE_16"/>
        <property name="misc-symbolic-icons-in-sidepane" type="bool" value="true"/>
        <property name="misc-open-new-window-as-tab" type="bool" value="false"/>
        <property name="misc-full-path-in-tab-title" type="bool" value="true"/>
        <property name="misc-show-delete-action" type="bool" value="false"/>
      </channel>
    '';
    force = true;
  };

  xdg.configFile."Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
      <action>
          <icon>utilities-terminal</icon>
          <name>Open Terminal Here</name>
          <unique-id>1700000000000001</unique-id>
          <command>ghostty -d %f</command>
          <description>Opens terminal in the selected folder</description>
          <patterns>*</patterns>
          <startup-notify/>
          <directories/>
      </action>
      <action>
          <icon></icon>
          <name>Extract here</name>
          <submenu></submenu>
          <unique-id>1689618425925956-3</unique-id>
          <command>xarchiver -x . %f</command>
          <description>Extracts the archive into the directory it is located in.</description>
          <range>*</range>
          <patterns>*.tar.bz2;*.tar.gz;*.tar.xz;*.tar.Z;*.tar;*.taz;*.tb2;*.tbz;*.tbz2;*.tgz;*.txz;*.zip;*.bz2;*.docx;*.apk;*.gz;*.odt;</patterns>
          <other-files/>
      </action>
      <action>
        <icon>package-x-generic</icon>
        <name>Compress here (tar.gz)</name>
        <submenu></submenu>
        <unique-id>1700000000000003</unique-id>
        <command>tar -czvf %n.tar.gz %N</command>
        <description>Creates a compressed archive (.tar.gz) of selected files/folders.</description>
        <range>*</range>
        <patterns>*</patterns>
        <directories/>
        <other-files/>
      </action>
    </actions>
  '';
}
