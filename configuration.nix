# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./vfio.nix
      ./hardware-configuration.nix
      ./cli.nix
    ];

  vfio.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.extra-substituters = [
    # binary sources for lix
    "https://cache.lix.systems"
  ];

  nix.settings.trusted-public-keys = [
    # binary sources for lix
    "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
  ];

  # Enable ntfs-3g - https://wiki.nixos.org/wiki/NTFS
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "computer"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the windowing system.
  programs.xwayland.enable = true;
  # Enable sddm in Wayland and plasma6 https://nixos.wiki/wiki/KDE
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  # Allow chromium/electron to use wayland - https://nixos.wiki/wiki/Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Autologin sddm
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/display-managers/sddm.nix
  services.displayManager.sddm.settings = {
    Autologin = {
      Session = "plasma.desktop";
      User = "user";
    };
  };
  programs.partition-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable sound.
  # https://nixos.wiki/wiki/PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };


  security.sudo.wheelNeedsPassword = false;

  # Define a user account
  users.users.user = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [ "wheel" "libvirtd" "wireshark" ]; 
    packages = with pkgs; [
      lazygit
      kitty
      gh # github cli
      chromium
      thunderbird
      vlc
      # discord https://github.com/Vencord/Vesktop
      vesktop
      obsidian
      sqlitebrowser
      webex
      prismlauncher
    ];
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    fira-code-nerdfont
    vim
    vscode.fhs
    kdePackages.sddm-kcm
    catppuccin
    catppuccin-kde
    catppuccin-gtk
    catppuccin-sddm
    easyeffects
    distrobox
    # languages and build tools
    rustup
    clang
    go
    gnumake
    git
    # for neovim
    ripgrep
    stylua
    wl-clipboard
  ];

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable Docker - https://nixos.wiki/wiki/Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  users.extraGroups.docker.members = [ "user" ];

  ## Programs

  # global shell setup
  #programs.zsh.enable = true;
  users.defaultUserShell = pkgs.bash;
  programs.tmux.enable = true;
  programs.starship.enable = true;

  # use the firefox program instead of package
  # to enable plasma-browser-integration (config installed by plasma)
  programs.firefox.enable = true;

  # fix theming in GTK applications with plasma https://github.com/NixOS/nixpkgs/issues/180720
  # plasma calls dconf to sync GTK theme settings when the settings are changed in plasma
  # so after enabling this the themes need to be set again.
  programs.dconf.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
  # https://github.com/quexten/goldwarden
  programs.goldwarden.enable = true;
  programs.goldwarden.useSshAgent = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.withRuby = true;
  programs.neovim.withPython3 = true;
  programs.neovim.withNodeJs = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
  };

  # Services

  # tailscale
  # https://github.com/tailscale/tailscale/issues/4254
  # https://nixos.wiki/wiki/Tailscale
  services.resolved.enable = true;
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.syncthing.enable = true;
  services.syncthing.user = "user";
  services.syncthing.dataDir = "/home/user";
  services.syncthing.configDir = "/home/user/.config/syncthing";

  # Enable AutoUpgrades - nixos-upgrade.service
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "23.11"; 
}

