{
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    ports = [ 22 ];
    banner = ''
      HEAVEN:

      This system is for the use of authorized users only. Individuals using this
      computer system without authority, or in excess of their authority, are
      subject to having all of their activities on this system monitored and
      recorded by system personnel.

      In the course of monitoring individuals improperly using this system, or in
      the course of system maintenance, the activities of authorized users may also
      be monitored.

      Anyone using this system expressly consents to such monitoring and is advised
      that if such monitoring reveals possible evidence of criminal activity,
      system personnel may provide the evidence of such monitoring to law
      enforcement officials.
    '';
  };
}
