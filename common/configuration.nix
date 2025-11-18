{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  # spicetify-nix = inputs.spicetify-nix;
  spicePkgs = inputs.spicetify-nix.packages;

  writeShellScriptBinAndSymlink = {
    name ? pkg,
    pkg,
    text,
  }:
    pkgs.symlinkJoin {
      name = name;
      paths = [
        (pkgs.writeShellScriptBin name text)
        pkgs."${pkg}"
      ];
    };
in {
  imports = [
  ];

  environment.etc = {
    "resolv.conf".text = "nameserver 1.1.1.1\nnameserver 8.8.8.8";
    "nixpkgs".source = (import ../npins).nixpkgs;
  };

  boot = {
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl."kernel.sysrq" = 1;
    initrd.systemd.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    gpm.enable = true;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd \"niri-session\"";
        };
      };
    };

    printing = {
      enable = true;
      drivers = [pkgs.cups-brother-hll2340dw];
    };

    speechd.enable = false;

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
    };

    syncthing = {
      enable = true;
      user = "calebh";
      group = "users";
      configDir = "/home/calebh/.config/syncthing";
      dataDir = "/home/calebh";
    };

    journald.extraConfig = "SystemMaxUse=1G";

    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
      ];
      configPackages = [
        pkgs.xdg-desktop-portal-gnome
      ];
    };
    icons = {
      enable = true;
      fallbackCursorThemes = ["catppuccin-mocha-dark-cursors"];
    };
  };

  nix = {
    settings = {
      system-features = ["fuse"];
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["*"];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    channel.enable = false;
    nixPath = ["nixpkgs=/etc/nixpkgs"];
  };

  # Enable networking
  # networking.networkmanager.enable = true;

  fonts.packages = [pkgs.nerd-fonts.droid-sans-mono];

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

  programs.niri.enable = true;

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };

  programs.virt-manager.enable = true;

  security = {
    rtkit.enable = true;
    sudo.extraConfig = "Defaults insults";
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [virtiofsd];
  };

  users.users.calebh = {
    isNormalUser = true;
    description = "Caleb Hess";
    extraGroups = [
      "networkmanager"
      "wheel"
      "qemu-libvirtd"
      "libvirtd"
      "video"
    ];
    packages = [
      # (writeShellScriptBinAndSymlink {
      #   pkg = "sway";
      #   name = "sway";
      #   text = ''
      #     exec ${pkgs.sway}/bin/sway --unsupported-gpu -c ${../configs/sway/config}
      #   '';
      # })
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    unzip
    file
    moreutils
    catppuccin-cursors.mochaDark
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
