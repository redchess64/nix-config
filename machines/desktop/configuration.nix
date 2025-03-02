{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  # networking.nameservers = [ "1.1.1.1" ];
  #   networking.dhcpcd.extraConfig = ''
  #   nohook resolv.conf
  # '';

  environment.etc = {
    "resolv.conf".text = "nameserver 1.1.1.1\n";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # seems to stop hyprland graphical glitchs
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu" ];
  

  virtualisation.docker.enable = true;


  nix = {
    settings.auto-optimise-store = true;
    settings.system-features = ["kvm" "fuse"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
  };


  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = ["kvm-amd"];

  networking.hostName = "desktop"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        lsp.enable = true;

        luaConfigRC = {
          a = ''
            vim.opt.list = true
            vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
          '';
        }; 

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;

          rust.enable = true;
          nix.enable = true;
          markdown.enable = true;
        };

         theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };                       

        mini = {
          basics.enable = true;
          completion.enable = true;
        };

        telescope.enable = true;

        extraPlugins = with pkgs.vimPlugins; {
          vim-sleuth = {
            package = vim-sleuth;
          };
        };
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    # nssmdns4 = true;
    openFirewall = true;
  };

  nix.settings.trusted-users = ["*"];

  # Enable sound with pipewire.

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.calebh = {
    isNormalUser = true;
    description = "Caleb Hess";
    extraGroups = [
      "networkmanager"
      "wheel"
      "qemu-libvirtd"
      "libvirtd"
      "kvm"
    ];
    packages = with pkgs; [
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    #  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.nix-ld.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  security.pam.services.hyprlock = {};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  wget
    home-manager
    git
    unzip
    gcc
    file
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
