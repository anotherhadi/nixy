# Nextcloud is a suite of client-server software for creating file hosting services and using them. It is functionally similar to Dropbox, although Nextcloud is free and open-source, allowing anyone to install and operate it on a private server. In contrast to proprietary services, Nextcloud can be hosted on a private server, without additional cost.
# This is the client, check /server-modules/nextcloud.nix for the server module.
{
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
