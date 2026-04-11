let
  spaces = import ./spaces.nix;
in {
  "Mail" = {
    id = "13a5d638-53f3-4abb-8498-ec6b4af74d4c";
    url = "https://mail.proton.me";
    workspace = spaces.Home.id;
    position = 1000;
  };

  "Drive" = {
    id = "271e6164-eb2e-4e9e-a0ad-634d6f442b40";
    url = "https://drive.proton.me";
    workspace = spaces.Home.id;
    position = 2000;
  };

  "Github" = {
    id = "cb41190e-d410-4da6-801c-4785c5d5993f";
    url = "https://github.com";
    workspace = spaces.Home.id;
    position = 3000;
  };
}
