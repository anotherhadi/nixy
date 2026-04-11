{...}: {
  ExtensionSettings = {
    "*" = {
      blocked_install_message = "The addon you are trying to install is not added in the Nix config";
      installation_mode = "blocked";
    };
    "adnauseam@rednoise.org" = {
      private_browsing = true;
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/latest.xpi";
    };
    "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
      private_browsing = true;
      default_area = "navbar";
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
    };
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
      private_browsing = true;
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
    };
    "jid1-MnnxcxisBPnSXQ@jetpack" = {
      private_browsing = true;
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
    };
    # View Xpi Id's in Firefox Extension Store
    "queryamoid@kaply.com" = {
      private_browsing = true;
      installation_mode = "force_installed";
      install_url = "https://github.com/mkaply/queryamoid/releases/download/v0.2/query_amo_addon_id-0.2-fx.xpi";
    };
  };
  "3rdparty".Extensions = {
    "adnauseam@rednoise.org" = {
      enabled = true;
      firstInstall = false;
      hidingAds = true;
      clickingAds = true;
      blockingMalware = true;
    };
  };
}
