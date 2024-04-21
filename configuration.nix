# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
	programs.git = {
		enable = true;
		config.credential.helper = "libsecret";
	};

	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	security.polkit.enable = true;
	security.sudo.wheelNeedsPassword = false;

	services.xserver.xkb = {
		layout = "fi";
	};
	console.keyMap = "fi";
	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
	};
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			package = pkgs.steam.override {
				extraPkgs = pkgs: with pkgs; [
						gamemode
						mangohud
                                                gamescope
						libpng
						libpulseaudio
						libvorbis
						stdenv.cc.cc.lib
						libkrb5
						keyutils
				];
			};
	};

	nixpkgs.config.allowUnfree = true;
	imports =
		[ 
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

	networking.networkmanager.enable = true;
	time.timeZone = "Europe/Vilnius";

	services.displayManager.sddm.enable = true;
	services.displayManager.defaultSession = "hyprland";
	services.xserver.enable = true;
	services.xserver.videoDrivers = [ "amdgpu" ];

	services.passSecretService.enable = true;
	nix.settings.experimental-features = [ "nix-command" "flakes" ]; 


	services.printing.enable = true;

	sound.enable = true;

	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
                extraPackages = with pkgs; [
                    vaapiVdpau
                    libvdpau-va-gl
            ];
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

	services.desktopManager.plasma6.enable = true;
	#services.xserver.desktopManager.cinnamon.enable = true;

	services.avahi = {
		enable = true;
		nssmdns4 = true;
		openFirewall = true;
	};

	users.defaultUserShell = pkgs.nushell;

	users.users.jesse = {
		isNormalUser = true;
		extraGroups = [ "audio" "keyd" "wheel" "adbusers" "qemu-libvirtd" "libvirtd" "disk"] ;
			packages = with pkgs; [
			firefox
				tree
				kitty
				htop
				discord
				brave
			];
	};
    

	environment.systemPackages = with pkgs; [
		    vim
			wget
			wezterm
			neofetch
			kitty
			killall
			wl-clipboard
			clipman
			hyprpaper
			hyprpicker
			udiskie
			wl-clip-persist
			rofi
			eww
			libreoffice-qt
			gammastep
			hunspell
			freerdp
			hunspellDicts.sv_FI
			xwaylandvideobridge
			wlogout
			wleave
			hunspellDicts.uk_UA
			jq
			pkg-config
			grim
			sqlitebrowser
			sqlite
			slurp
			obs-studio
			mpv
			betterbird
			bibata-cursors
			gcc
			unrar
			libGL
			nodejs
			insomnia
			vesktop
			wayland-scanner
			libsecret
			tutanota-desktop
			papirus-icon-theme
			kdePackages.polkit-kde-agent-1
			kdePackages.kalk
			kdePackages.kirigami
			kdePackages.dolphin
			kdePackages.sonnet
			libsForQt5.kio
                        teams-for-linux
			play-with-mpv
			libsForQt5.kio-extras
			libsForQt5.kimageformats
			libsForQt5.kdegraphics-thumbnailers
			libsForQt5.kservice
			kdePackages.kio-fuse
			kdePackages.kpat
                        nixos-bgrt-plymouth
			wmctrl
                        yazi
			libunity
			dracula-theme
			dotnet-sdk
			mono
			dotnet-runtime
			nwg-look
			kdePackages.kate
			ghc
			(haskellPackages.ghcWithPackages ( pkgs: with pkgs; [pkgs.raw-strings-qq pkgs.hostname]))
			hyprlock
			hyprcursor
			hypridle
			haskellPackages.aeson
			whatsapp-for-linux
			gimp
			rofi-power-menu
			libnotify
			unzip
			libvoikko
			nushell
			piper
			cargo
                        python312Packages.matplotlib
                        python312Packages.numpy
                        google-chrome
                        appimage-run
                        wineWowPackages.stable
                        wineWowPackages.waylandFull
			dunst
                        vscode
			jetbrains.idea-community
			jetbrains.pycharm-community
                        jetbrains.webstorm
                        libsForQt5.polkit-kde-agent
			cmatrix
			zoom-us
			exfatprogs
			virt-manager
			ntfs3g
			zellij
			tofi
			looking-glass-client
			ventoy-full
			ncurses
			pavucontrol
			samba
			fuseiso
			home-manager
			mullvad-vpn
			kdePackages.kolourpaint
			floorp
			python3
			playonlinux
			stdenv.cc.cc
			];
			
        environment.sessionVariables.NIXOS_OZONE_WL = "1";

	services.mullvad-vpn.enable = true;
	services.onedrive.enable = true;

	services.samba.enableWinbindd = true;

	programs.java.enable = true;
	programs.adb.enable = true;
	programs.nix-ld.enable = true;
	virtualisation.libvirtd.enable = true;
	virtualisation.libvirtd.qemu.ovmf.enable = true;
	programs.virt-manager.enable = true;

	security.pam.services.sddm.enableKwallet = true;

	services.gvfs.enable = true;
	services.ratbagd.enable = true;
        
        services.openssh = {
  	 enable = true;
  	 # require public key authentication for better security
  	 settings.PasswordAuthentication = false;
  	 settings.KbdInteractiveAuthentication = false;
 	 settings.PermitRootLogin = "yes";
	};

	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	networking.firewall.enable = false;

	fonts.fontconfig.enable = true;

	system.stateVersion = "23.11"; 
}
