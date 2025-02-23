# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

with {
	user_packages = (import ./user-packages.nix) pkgs;
};
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
	nixpkgs.config.permittedInsecurePackages = [
                "electron-25.9.0"
              ];
              
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;
	systemd.user.services.mpris-proxy = {

		description = "Mpris proxy";
		after = [ "network.target" "sound.target" ];
		wantedBy = [ "default.target" ];
		serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
	};

	hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
		  load-module module-bluetooth-policy
		  load-module module-bluetooth-discover
		  ## module fails to load with 
		  ##   module-bluez5-device.c: Failed to get device path from module arguments
		  ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
		  # load-module module-bluez5-device
		  # load-module module-bluez5-discover
	'';

  #hardware.graphics.extraPackages = [
  #  pkgs.intel-media-driver
  #];

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.xserver = {
    enable=true;
    
    xkb = {
      layout = "nz";
      variant = "";
    };

    windowManager.i3 = {
	    enable=true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };

  
  services.displayManager = {
    defaultSession = "none+i3";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  users.users.leastinformednerd = {
	isNormalUser = true;
	extraGroups = [ "wheel"
		"networkmanager"
    "video"
	];
	group = "leastinformednerd";
	home = "/home/leastinformednerd";
	createHome = true;
	packages = user_packages.leastinformednerd;
  };

  programs.steam.enable = true;

  users.groups.leastinformednerd = {};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    lightdm
    alacritty
    pipewire
    pulseaudio
    pavucontrol
   ];

  services.xserver.displayManager.lightdm.background = "/usr/share/background.png";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  #Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

