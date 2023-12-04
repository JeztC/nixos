# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  programs.zsh.interactiveShellInit = ''
  export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

  # Customize your oh-my-zsh options here
  ZSH_THEME="dracula"
  plugins=(git)

  source $ZSH/oh-my-zsh.sh
'';

  programs.zsh.enable = true;
  programs.zsh.promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh
  programs.hyprland = {
  enable = true;
  xwayland.enable = true;
  };
    programs.git = {
    enable = true;
    lfs.enable = true;
  };

    boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
  #nixpkgs.config.pulseaudio = true;
  nixpkgs.config.allowUnfree = true;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

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
  
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.enable = true;
  
  # Secrets Provider
  services.passSecretService.enable = true;
  # Gnome Keyring
  services.gnome.gnome-keyring.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  
  #wayland.windowManager.hyprland.plugins = [];
  # Configure keymap in X11
  services.xserver.xkb.layout = "fi";
  services.xserver.xkbOptions = "caps:ctrl_modifier";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;

  hardware.opengl = {
  enable = true;
  extraPackages = with pkgs; [ vaapiVdpau ];
  };

  fonts.packages = with pkgs; [
  font-awesome
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  vistafonts
  corefonts
  dejavu_fonts
  (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

    fonts.fontconfig.defaultFonts = {
    monospace = [
      "terminus"
      "DejaVu Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "terminus"
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "terminus"
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.printing.enable = true;
  
  services.avahi = {
  enable = true;
  nssmdns = true;
  openFirewall = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jesse = {
     isNormalUser = true;
     extraGroups = [ "wheel" "libvirtd" "adbusers" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       firefox
       tree
       kitty
       htop
       discord
       brave
       runelite
     ];
   };
   
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     wezterm
     neofetch
     waybar
     killall
     gamescope
     vscodium
     wl-clipboard
     hyprpaper
     hyprpicker
     udiskie
     rofi
     libreoffice-qt
     gammastep
     hunspell
     hunspellDicts.sv_FI
     plasma5Packages.dolphin
     jq
     pkg-config
     grimblast
     obs-studio
     mpv
     jetbrains.clion
     gcc
     nodejs
     wayland-scanner
     wgnord
     dunst
     libsecret
     tutanota-desktop
     gnome.libgnome-keyring
     ciscoPacketTracer8
     papirus-icon-theme
     dracula-theme
     nwg-look
     jmtpfs
     godot3-mono
     kate
     thunderbird
     zsh
     oh-my-zsh
     zsh-syntax-highlighting
     teams-for-linux
   ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  programs.adb.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # vpn configurations
  services.openvpn.servers = {
    nordvpn_swiss373 = { config = '' config /home/jesse/ch373.nordvpn.com.tcp443.ovpn ''; };
    #officeVPN  = { config = '' config /root/nixos/openvpn/officeVPN.conf ''; };
    #homeVPN    = { config = '' config /root/nixos/openvpn/homeVPN.conf ''; };
    #serverVPN  = { config = '' config /root/nixos/openvpn/serverVPN.conf ''; };
  };

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

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

