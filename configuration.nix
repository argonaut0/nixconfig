# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  console.earlySetup = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" ];


  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default
  # wpa_supplicant broken 2.11 + does not support wpa3 on broadcom
  # https://bugzilla.redhat.com/show_bug.cgi?id=2302577
  networking.networkmanager.wifi.backend = "iwd";


  # fuck you systemd broken ass crap
  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.systemd-udevd.restartIfChanged = false;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    # TO ENABLE IN PLASMA SETTINGS:
    # System Settings -> Virtual Keyboard -> select Fcitx5
    # System Settings -> Input Method -> Add Input Method...
    # DO NOT SELECT "Fcitx5 Wayland Launcher" it will not work -> causes "Rime (not available)".
    enable = true;
    type = "fcitx5";
    # https://wiki.archlinux.org/title/Input_method
    # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Applications
    fcitx5.plasma6Support = true;
    # unsets QT_IM_MODULE and other env.
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
        rime-data
        #brise
        fcitx5-mozc
        librime
        fcitx5-rime
        fcitx5-configtool
        fcitx5-chinese-addons
      ];
  };


  # Enable the windowing system.
  programs.xwayland.enable = true;
  # Enable sddm in Wayland and plasma6 https://nixos.wiki/wiki/KDE
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.theme = "catppuccin-mocha";
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
  # KDE partition manager
  programs.partition-manager.enable = true;
  # fix theming in GTK applications with plasma https://github.com/NixOS/nixpkgs/issues/180720
  # plasma calls dconf to sync GTK theme settings when the settings are changed in plasma
  # so after enabling this the themes need to be set again.
  programs.dconf.enable = true;

  environment.etc."xdg/kdeglobals" = {
    text = ''
      [General]
      ColorScheme[$i]=CatppuccinFrappeBlue
      XftAntialias[$i]=true
      XftHintStyle[$i]=hintfull
      XftSubPixel[$i]=rgb
      fixed=FiraCode Nerd Font Mono,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

      [Icons]
      Theme[$i]=breeze-dark

      [KDE]
      LookAndFeelPackage[$i]=Catppuccin-Frappe-Blue
    '';
  };

  environment.etc."xdg/kwinrc" = {
    text = ''
      [Plugins]
      cubeEnabled=true
      wobblywindowsEnabled=true

      [org.kde.kdecoration2]
      library[$i]=org.kde.breeze
      theme[$i]=Breeze
    '';
  };

  nixpkgs.config.allowUnfree = true;

  # https://nix.dev/guides/faq#how-to-run-non-nix-executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ]; 

  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;

  programs.ccache.enable = true;
  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
  nixpkgs.overlays = [
    # https://nixos.wiki/wiki/CCache
    (self: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
        export CCACHE_COMPRESS=1
        export CCACHE_DIR="${config.programs.ccache.cacheDir}"
        export CCACHE_UMASK=007
        if [ ! -d "$CCACHE_DIR" ]; then
          echo "====="
          echo "Directory '$CCACHE_DIR' does not exist"
          echo "Please create it with:"
          echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
          echo "  sudo chown root:nixbld '$CCACHE_DIR'"
          echo "====="
          exit 1
        fi
        if [ ! -w "$CCACHE_DIR" ]; then
          echo "====="
          echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
          echo "Please verify its access permissions"
          echo "====="
          exit 1
        fi
        '';
      };
    })
  ];
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

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

  programs.xonsh.enable = true;
  programs.xonsh.config = "
    $XONSH_APPEND_NEWLINE = False
    $COMPLETIONS_CONFIRM = False
    execx($(starship init xonsh))
    ";

  users.defaultUserShell = pkgs.bash;
  # Define a user account
  users.users.user = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [ "wheel" "libvirtd" "wireshark" "dialout" "networkmanager" ]; 
    packages = with pkgs; [
      lazygit
      #kitty
      gh # github cli
      vlc
      #packer
      #thunderbird
      # discord https://github.com/Vencord/Vesktop
      vesktop
      obsidian
      calibre
      sqlitebrowser
      reaper
      ardour
      musescore
      kdenlive
      #webex
      rawtherapee
      prismlauncher
      libreoffice-qt6
      #chromium
      #slack
    ];
  };

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim
    sqlite
    nix-search-cli
    nixpkgs-fmt
    nixpkgs-lint
    nixpkgs-manual
    devenv
    starship
    vscode.fhs
    kdePackages.sddm-kcm
    kdePackages.filelight
    kdePackages.yakuake
    kdePackages.qtimageformats # for dolphin image previews
    # end
    activitywatch
    catppuccin
    catppuccin-kde
    catppuccin-gtk
    catppuccin-sddm
    easyeffects
    distrobox
    bat
    # misc tools
    pciutils
    dig
    htop
    wget
    zip
    unzip
    kubectl
    kubectl-node-shell
    k9s
    kubernetes-helm
    # https://tofuutils.github.io/tenv/
    tenv
    tree
    sops
    pipenv
    file
    # languages and build tools
    rustup
    clang
    gcc
    gleam
    go
    nodejs
    deno
    bun
    erlang
    gnumake
    git
    exfatprogs
    # for neovim
    ripgrep
    stylua
    wl-clipboard
    fzf
  ];
  programs.fzf.fuzzyCompletion = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];


  ## Programs

  services.flatpak.enable = true;

  # Syncthing
  services.syncthing.enable = true;
  services.syncthing.user = "user";
  services.syncthing.dataDir = "/home/user";
  services.syncthing.configDir = "/home/user/.config/syncthing";

  # tailscale
  # https://github.com/tailscale/tailscale/issues/4254
  # https://nixos.wiki/wiki/Tailscale
  services.resolved.enable = true;
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # use the Firefox program instead of package
  # to enable plasma-browser-integration (config installed by plasma)
  programs.firefox.enable = true;
  programs.firefox.preferences = {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
  };

  # Wireshark
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # global shell setup
  # https://nixos.wiki/wiki/Tmux
  programs.tmux.enable = true;
  programs.starship.enable = true;

  # Neovim owo
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.withRuby = true;
  programs.neovim.withPython3 = true;
  programs.neovim.withNodeJs = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.cups-pdf.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Enable AutoUpgrades - nixos-upgrade.service
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

}
