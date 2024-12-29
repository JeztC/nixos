# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true; # Sorry Stallman (⸝⸝⸝O﹏ O⸝⸝⸝)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 2;
    efi.canTouchEfiVariables = true;
  };

  # The most obvious choice for hostname.
  networking.hostName = "matrix";

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  };

  users.defaultUserShell = pkgs.nushell;

  security.sudo.wheelNeedsPassword = false;

  console.keyMap = "fi";

   users.users.jesse = {
     isNormalUser = true;
     extraGroups = [ "wheel" "wireshark" ]; # Enable ‘sudo’ for the user.
     # All user packages
     packages = with pkgs; [
       tree
       htop
       neofetch
       cmatrix
       runelite
     ];
   };

   # But hey, at least it's Valve right?
     	programs.steam = {
		enable = true;
        gamescopeSession.enable = true;
		remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			package = pkgs.steam.override {
				extraPkgs = pkgs: with pkgs; [
					mangohud
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
	   jetbrains-mono
       corefonts
	];

	fonts.fontconfig.subpixel.lcdfilter = "light";
	fonts.fontconfig.hinting.style = "full";

    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl nvidia-vaapi-driver ];
      };
    };

    services = {
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
        };
      };
    };

   environment.sessionVariables.NIXOS_OZONE_WL = "1";

   programs.dconf.enable = true;
   programs.nix-ld.enable = true;
   programs.git.enable = true;
   programs.firefox = { enable = true; package = pkgs.firefox-devedition-bin; };
   programs.java = { enable = true; package = pkgs.jdk11; };
   programs.obs-studio.enable = true;
   programs.vim.enable = true;
   programs.wireshark = { enable = true; package = pkgs.wireshark; };
   systemd.services.lactd.enable = true;

  # All system packages.
  environment.systemPackages = with pkgs; [
    wget
    mpv
    vscodium-fhs

    python3
    kdePackages.kolourpaint
    libreoffice-qt6-fresh
    github-desktop
    thunderbird-latest
    teams-for-linux
    pciutils
    toybox
    unrar
    jre8
    kitty
    discord
    kdePackages.partitionmanager
    kdePackages.kcolorpicker
    discord-canary
    blender
    postman
    kdePackages.plasma-browser-integration
    jetbrains.pycharm-community-bin
    jetbrains.webstorm
    jetbrains.idea-community-bin
    jetbrains.rider
    lact
    hyprshot
    obsidian
    hunspell
    hunspellDicts.sv_FI
    (brave.override {
          # Some of these flags correspond to chrome://flags
          commandLineArgs = [
            # Correct fractional scaling.
            "--ozone-platform-hint=wayland"
            # Hardware video encoding on Chrome on Linux.
            # See chrome://gpu to verify.
             "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks"
          ];
        })
   ];

    security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.openrazer.users = ["jesse"];
  hardware.openrazer.enable = true;

  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.mullvad-vpn = { enable = true; package = pkgs.mullvad-vpn; };

  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";
  environment.sessionVariables.FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  environment.sessionVariables.DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
  environment.sessionVariables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";
  environment.sessionVariables.NVD_BACKEND = "direct";
  environment.sessionVariables.WEBKIT_DISABLE_DMABUF_RENDERER = "1";

  system.stateVersion = "24.11";

}
