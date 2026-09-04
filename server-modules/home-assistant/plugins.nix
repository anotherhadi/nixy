# Custom (non-core) Home Assistant integrations built from source.
{pkgs, ...}: let
  idfm-api = pkgs.home-assistant.python3Packages.buildPythonPackage rec {
    pname = "idfm-api";
    version = "1.3.1";
    pyproject = true;
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/source/i/idfm-api/idfm_api-${version}.tar.gz";
      hash = "sha256-j9whladp+nTUd6dnB0EybOiG2xQ7OyLf6LN3MpzjZv0=";
    };
    build-system = [pkgs.home-assistant.python3Packages.setuptools];
    dependencies = with pkgs.home-assistant.python3Packages; [aiohttp async-timeout];
    doCheck = false;
  };

  idfm = pkgs.buildHomeAssistantComponent {
    owner = "droso-hass";
    domain = "idfm";
    version = "2.3.1";
    src = pkgs.fetchFromGitHub {
      owner = "droso-hass";
      repo = "idfm";
      tag = "v2.3.1";
      hash = "sha256-Zlgd6TXxipcfUcdOyOpLcchM9DO84jCCtREFgbGRcY4=";
    };
    dependencies = [idfm-api];
  };

  atomic-calendar-revive = pkgs.stdenvNoCC.mkDerivation {
    pname = "atomic-calendar-revive";
    version = "10.3.1";
    src = pkgs.fetchurl {
      url = "https://github.com/totaldebug/atomic-calendar-revive/releases/download/v10.3.1/atomic-calendar-revive.js";
      hash = "sha256-F4vXHQRAsiaK/ylL4X5d70TBxukMAqeQixb6XE68yZo=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir $out
      cp $src $out/atomic-calendar-revive.js
    '';
  };
in {
  customComponents = [idfm];
  customLovelaceModules = [atomic-calendar-revive];
}
