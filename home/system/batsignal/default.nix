# Batsignal is a simple utility to send battery notifications.
{
  services.batsignal = {
    enable = true;
    extraArgs = [ "-c 10" "-w 30" "-f disabled" ];
  };
}
