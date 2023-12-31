# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  
  programs.zsh.interactiveShellInit = ''
  export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

  # Customize your oh-my-zsh options here
  # ZSH_THEME="dracula"
  plugins=(git)

  source $ZSH/oh-my-zsh.sh
'';
  
  programs.git = {
  enable = true;
  # ...
};
  programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  ohMyZsh.enable = true;
  ohMyZsh.plugins = [ "git" ];
  syntaxHighlighting.enable = true;
  };
 
  #programs.zsh.enable = true;
  #programs.zsh.promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh
  programs.hyprland = {
  enable = true;
  xwayland.enable = true;
  };

    boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  package = pkgs.steam.override {
  extraPkgs = pkgs: with pkgs; [
    gamescope
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
  #nixpkgs.config.pulseaudio = true;
  nixpkgs.config.allowUnfree = true;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
        extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
          libgdiplus
        ]);
      });
    })
  ];

  # Use the systemd-boot EFI boot loader.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.configurationLimit = 2;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "hyprland";
  services.xserver.enable = true;
  
  # Secrets Provider
  services.passSecretService.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  
  #wayland.windowManager.hyprland.plugins = [];
  # Configure keymap in X11
  services.xserver.xkb.layout = "fi";
  #services.xserver.xkb.options = "ctrl:nocaps";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;

  hardware.opengl = {
  enable = true;
  driSupport = true;
  driSupport32Bit = true;
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
  fontconfig
  twemoji-color-font
  fira-code
  fira-code-symbols
  nerdfonts
  (nerdfonts.override { fonts = [ "RobotoMono"  ]; })
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
  
  services.avahi = {
  enable = true;
  nssmdns = true;
  openFirewall = true;
  };
 
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jesse = {
     isNormalUser = true;
     extraGroups = [ "wheel" "adbusers" "qemu-libvirtd" "libvirtd" "disk"] ; # Enable ‘sudo’ for the user.
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
     vscodium
     wl-clipboard
     clipman
     hyprpaper
     hyprpicker
     udiskie
     wl-clip-persist
     rofi
     libreoffice-qt
     gammastep
     hunspell
     hunspellDicts.sv_FI
     hunspellDicts.uk_UA
     jq
     pkg-config
     grimblast
     obs-studio
     mpv
     jetbrains.clion
     gcc
     nodejs
     wayland-scanner
     libsecret
     tutanota-desktop
     papirus-icon-theme
     libsForQt5.polkit-kde-agent
     dracula-theme
     nwg-look
     godot3-mono
     kate
     thunderbird
     zsh
     oh-my-zsh
     zsh-syntax-highlighting
     teams-for-linux
     gnome.seahorse
     gimp
     rofi-power-menu
     libnotify
     unzip
     libvoikko
     piper
     dunst
     jetbrains.idea-community
     jetbrains.webstorm
     cmatrix
     wineWowPackages.stable
     wine
    (wine.override { wineBuild = "wine64"; })
     wineWowPackages.staging
     winetricks
     wineWowPackages.waylandFull
     libglvnd
     xdg-desktop-portal-gtk
     zoom-us
     exfatprogs
     dotnet-sdk
     cypress
     virt-manager
     ntfs3g
     looking-glass-client
     ventoy-full
     ncurses
     pavucontrol
     sdbus-cpp
     vscode
     adoptopenjdk-bin
     xorg.xkbcomp
     home-manager
     (vscode-with-extensions.override {
     vscode = vscodium;
     vscodeExtensions = with vscode-extensions; [
     ms-python.python
     ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "test-my-code";
        publisher = "moocfi";
        version = "2.2.4";
        sha256 = "c+UfNYNs56BhbWOsZbI4E8JKH3u6VGsFO3BxG/OwVNY=";
      }
    ];
   })
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

  virtualisation.libvirtd.enable = true;
  #programs.virt-manager.enable = true;

  # vpn configurations
  services.openvpn.servers = {
    nordvpn_ee1194 = { config = '' config /home/jesse/vpnconfig/ee54.nordvpn.com.udp1194.ovpn ''; };
  };
   
  
  security.pam.services.kwallet = {
   name = "kwallet";
   enableKwallet = true;
  };

  #security.pam.services.services.enableKwallet = true;

  services.gvfs.enable = true;
  services.ratbagd.enable = true;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
 
  #security.pam.services.login.enableKwallet = true;

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

  fonts.fontconfig.enable = true;

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

