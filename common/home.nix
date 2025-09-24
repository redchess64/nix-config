{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "calebh";
  home.homeDirectory = "/home/calebh";

  home.file = {
    ".config" = {
      source = ../configs;
      recursive = true;
    };
  };

  home.packages = with pkgs; [
    # Desktop applications
    vesktop
    aseprite
    prismlauncher
    nemo
    nautilus
    kdePackages.kate
    element-desktop
    drawing

    # CLI applications
    neofetch
    yt-dlp
    fzf
    qemu
    packwiz
    just
    gamescope
    jq
    libnotify
    distrobox
    pakku

    # Sway utilitys
    wl-clipboard
    mako
    autotiling
    playerctl

    # Niri utilitys
    xwayland-satellite
    gnome-keyring
    swaybg
    swayidle
    swaylock
    wmenu

    # Other
    # nerdfonts.droid-sans-mono
    wev
    lm_sensors
  ];

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "catppuccin-mocha-dark-cursors";
    size = 32;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      size = 24;
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
    };
  };

  programs.git = {
    enable = true;
    userName = "Caleb Hess";
    userEmail = "redchess64@gmail.com";
    extraConfig = {
      core.askPass = "";
      credential.helper = "store";
    };
  };

  programs.alacritty.enable = true;

  #   programs.neovim = {
  #     enable = true;
  #     viAlias = true;
  #     vimAlias = true;
  #   };

  home.shellAliases = {
    l = "ls -lAh";
    "nrs" = "sudo nixos-rebuild switch";
    get = "nix-shell -p ";
    rm = "rm -I";
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export VISUAL="nvim";
      export EDITOR="nvim";
      export XDG_DATA_HOME="$HOME/.local/share";
      export XDG_CONFIG_HOME="$HOME/.config";
      export XDG_STATE_HOME="$HOME/.local/state";
      export XDG_CACHE_HOME="$HOME/.cache";
      export HISTFILE="$XDG_STATE_HOME/bash/history";
      export CARGO_HOME="$XDG_DATA_HOME/cargo";
      export MOZ_ENABLE_WAYLAND=1;
      export _JAVA_AWT_WM_NONREPARENTING=1
      export ELECTRON_OZONE_PLATFORM_HINT=auto;
      export NIXOS_OZONE_WL=1;
      export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc;
    '';
  };

  programs.bat.enable = true;
  programs.btop.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
