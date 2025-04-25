{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  imports = [
    ./hardware-configuration.nix
  ];

  environment.etc = {
    "resolv.conf".text = "nameserver 1.1.1.1\nnameserver 8.8.8.8";
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
    };
    kernelPackages = pkgs.linuxPackages;
    kernelModules = ["kvm-amd"];
    kernel.sysctl."kernel.sysrq" = 1;
  };

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    printing.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    syncthing = {
      enable = true;
      user = "calebh";
      group = "users";
      configDir = "/home/calebh/.config/syncthing";
      dataDir = "/home/calebh";
    };

    flatpak.enable = true;
  };

  virtualisation.docker.enable = true;

  nix = {
    settings = {
      system-features = ["kvm" "fuse"];
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["*"];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

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

        options = {
          tabstop = 4;
          shiftwidth = 4;
          expandtab = false;
          list = true;
        };

        luaConfigRC = {
          a = ''
            vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
          '';
        };

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;

          rust.enable = true;
          nix.enable = true;
          java.enable = true;
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

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };

  security.rtkit.enable = true;

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
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    #  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.nix-ld.enable = true;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "vesktop"
      "steam"
      "steam-unwrapped"
      "aseprite"
      "spotify"
      "nvidia-x11"
      "nvidia-settings"
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    home-manager
    git
    unzip
    file
    moreutils
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
  system.stateVersion = "24.11"; # Did you read the comment?
}
