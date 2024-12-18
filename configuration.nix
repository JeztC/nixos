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

# Enables GRUB.
boot.loader = {
  efi = {
    canTouchEfiVariables = false;
  };
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      splashImage = null;
      theme = "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
    };
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
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     # All user packages
     packages = with pkgs; [
       tree
       htop
       neofetch
       cmatrix
       # Hide your eyes!
           (microsoft-edge.override {
          # Some of these flags correspond to chrome://flags
          commandLineArgs = [
            # Correct fractional scaling.
            "--ozone-platform-hint=wayland"
            # Hardware video encoding on Chrome on Linux.
            # See chrome://gpu to verify.
            "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks"
          ];
        })
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

    hardware = {
      graphics = {
        enable = true;
		enable32Bit = true;
        extraPackages = with pkgs; [ vaapiVdpau nvidia-vaapi-driver ];
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
   programs.java = { enable = true; package = pkgs.jre8; };
   programs.obs-studio.enable = true;

   systemd.services.lactd.enable = true;

  # All system packages.
  environment.systemPackages = with pkgs; [
    vim
    wget
    vscodium-fhs
    mpv
    python3
    kdePackages.kolourpaint
    libreoffice-qt6-fresh
    github-desktop
    thunderbird-latest
    teams-for-linux
    unrar
    discord
    kdePackages.kcolorpicker
    discord-canary
    #godot_4-mono
    blender
    kdePackages.plasma-browser-integration
    jetbrains.pycharm-community-bin
    jetbrains.webstorm
    jetbrains.idea-community-bin
    jetbrains.rider
    lact
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

  # NVIDIA stuff.
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = true;

    powerManagement.finegrained = false;

    # Oh noo proprietary..
    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "565.77";
      sha256_64bit = "sha256-CnqnQsRrzzTXZpgkAtF7PbH9s7wbiTRNcM0SPByzFHw=";
      sha256_aarch64 = lib.fakeSha256;
      openSha256 = lib.fakeSha256;
      settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
      persistencedSha256 = lib.fakeSha256;
    };

  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.mullvad-vpn = { enable = true; package = pkgs.mullvad-vpn; };

  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";
  environment.sessionVariables.DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
  environment.sessionVariables.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.libGL}/lib";
  environment.sessionVariables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";
  environment.sessionVariables.GBM_BACKEND = "nvidia-drm";
  environment.sessionVariables.NVD_BACKEND = "direct";
  environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";
  environment.sessionVariables.MOZ_DISABLE_RDD_SANDBOX = "1";

  system.stateVersion = "24.05";

}
