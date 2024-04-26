# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    programs.hyprland = {
     enable = true;
     xwayland.enable = true;
    };

    programs.git = {
	enable = true;
	config.credential.helper = "libsecret";
    };

  # Use the systemd-boot EFI boot loader.
  nixpkgs.config.allowUnfree = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  services.xserver.xkb = {
     layout = "fi";
  };

	xdg.portal = {
		enable = true;
	};

  console.keyMap = "fi";

  services.desktopManager.plasma6.enable = true;  
  services.displayManager.sddm.enable = true;
  services.xserver.enable = true;
  security.sudo.wheelNeedsPassword = false;

  users.defaultUserShell = pkgs.nushell;

  	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
                extraPackages = with pkgs; [
                    vaapiVdpau
                    libvdpau-va-gl
            ];
	};
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;


  security.pam.services.sddm.enableKwallet = true;
  services.passSecretService.enable = true;

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  security.pam.services.login.enableKwallet = true;


  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jesse = {
     isNormalUser = true;
     extraGroups = [ "wheel" "qemu-libvirtd" "libvirtd" "disk" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       firefox
       tree
       discord
       runelite
     ];
   };

 
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
        pulse.enable = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     htop
     mullvad-vpn
     wineWowPackages.waylandFull
     libreoffice-qt
     vscode
     wl-clipboard
     wl-clip-persist
     kitty
     wezterm
     jetbrains.pycharm-community
     play-with-mpv
     tofi
     cargo
     teams-for-linux
     gammastep
     xwaylandvideobridge
     grim
     sqlitebrowser
     sqlite
     obs-studio
     mpv
     betterbird
     nwg-look
     libnotify
     gcc
     unrar
     nodejs
     insomnia
     hyprpaper
     hypridle
     hyprlock
     hyprpicker
     tutanota-desktop
     gimp
     unzip
     eww
     nushell
     dunst
     jq
     slurp
     ghc
     bibata-cursors
     fuseiso
     libsForQt5.polkit-kde-agent
     kdePackages.kolourpaint
     libsForQt5.kio-extras
	 libsForQt5.kimageformats
	 libsForQt5.kdegraphics-thumbnailers
	 libsForQt5.kservice
	 kdePackages.kalk
	 kdePackages.kio-fuse
	 kdePackages.kpat
     kdePackages.kirigami
     libsForQt5.kwallet-pam
     kdePackages.sonnet
     python3
     cmatrix
     neofetch
   ];
 
  	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			package = pkgs.steam.override {
				extraPkgs = pkgs: with pkgs; [
						gamescope
						gamemode
						mangohud
						xorg.libXcursor
						xorg.libXi
						xorg.libXinerama
						xorg.libXScrnSaver
						libpng
						libpulseaudio
						libvorbis
						stdenv.cc.cc.lib
						libkrb5
						keyutils
				];
			};
	};



  	fonts.packages = with pkgs; [
	   vistafonts
           corefonts
	];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  environment.sessionVariables.MOZ_DISABLE_RDD_SANDBOX = "1";
  environment.sessionVariables.NVD_BACKEND = "direct";

  services.mullvad-vpn.enable = true;
  programs.java.enable = true;
  programs.nix-ld.enable = true;
  

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  programs.virt-manager.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
