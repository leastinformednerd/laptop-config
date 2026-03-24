{ config, pkgs, ...}:
{
  config.systemd.user.services."1password-daemon" = {
    enable = true;
    # name = "1password_daemon.service";
    unitConfig = {
      Description = "Starts 1password GUI";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
    };
  };
}
