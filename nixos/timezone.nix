{ config, ... }: {
  time.timeZone = config.var.timeZone;
  i18n.defaultLocale = config.var.defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = config.var.extraLocale;
    LC_IDENTIFICATION = config.var.extraLocale;
    LC_MEASUREMENT = config.var.extraLocale;
    LC_MONETARY = config.var.extraLocale;
    LC_NAME = config.var.extraLocale;
    LC_NUMERIC = config.var.extraLocale;
    LC_PAPER = config.var.extraLocale;
    LC_TELEPHONE = config.var.extraLocale;
    LC_TIME = config.var.extraLocale;
  };
}
