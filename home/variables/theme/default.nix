{ config, ... }: {
  imports = [ ./nixy.nix ];
  config.theme.colors.primary-ansi-16-number =
    if config.theme.colors.primary-ansi-16 == "black" then
      0
    else if config.theme.colors.primary-ansi-16 == "red" then
      1
    else if config.theme.colors.primary-ansi-16 == "green" then
      2
    else if config.theme.colors.primary-ansi-16 == "yellow" then
      3
    else if config.theme.colors.primary-ansi-16 == "blue" then
      4
    else if config.theme.colors.primary-ansi-16 == "magenta" then
      5
    else if config.theme.colors.primary-ansi-16 == "cyan" then
      6
    else if config.theme.colors.primary-ansi-16 == "white" then
      7
    else if config.theme.colors.primary-ansi-16 == "bright-white" then
      8
    else if config.theme.colors.primary-ansi-16 == "bright-black" then
      9
    else if config.theme.colors.primary-ansi-16 == "bright-red" then
      10
    else if config.theme.colors.primary-ansi-16 == "bright-green" then
      11
    else if config.theme.colors.primary-ansi-16 == "bright-yellow" then
      12
    else if config.theme.colors.primary-ansi-16 == "bright-blue" then
      13
    else if config.theme.colors.primary-ansi-16 == "bright-magenta" then
      14
    else if config.theme.colors.primary-ansi-16 == "bright-cyan" then
      15
    else
      0;

}
