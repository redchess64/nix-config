{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  discord = pkgs.writeShellScriptBin "discord" ''
    XDG_SESSION_TYPE=x11 ${pkgs.discord}/bin/discord
  '';
in

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "calebh";
  home.homeDirectory = "/home/calebh";

  home.file.".config/i3/config" = {
    source = ./configs/i3/config;
    recursive = true; # link recursively
    executable = true; # make all files executable
  };

  home.file.".config/polybar/" = {
    source = ./configs/polybar;
    recursive = true;
    executable = true;
  };

  home.file.".config/nvim/" = {
    source = ./configs/nvim;
    recursive = true;
  };

  home.file.".config/hypr/" = {
    source = ./configs/hypr;
    recursive = true;
  };

  home.file.".config/waybar/" = {
    source = ./configs/waybar;
    recursive = true;
  };

  home.file.".config/lock_background.png" = {
    source = ./configs/lock_background;
    # recursive = true;
  };

  home.file.".config/background.png" = {
    source = ./configs/background;
  };
  home.packages = with pkgs; [
    discord
    neofetch
    hypridle
    nemo
    bemenu
    waybar
    nerd-fonts.droid-sans-mono
    hyprshot
    hyprpolkitagent
    hyprpaper
    prismlauncher
    aseprite
    yt-dlp
    kdePackages.xwaylandvideobridge
    comma
  ];

  home.pointerCursor.package = pkgs.catppuccin-cursors.mochaDark;
  home.pointerCursor.name = "catppuccin-mocha-dark-cursors";
  home.pointerCursor.size = 32;
  home.pointerCursor.hyprcursor.size = 32;
  gtk.cursorTheme.size = 32;
  gtk.cursorTheme.package = pkgs.catppuccin-cursors.mochaDark;
  gtk.cursorTheme.name = "catppuccin-mocha-dark-cursors";

  gtk.enable = true;

  programs.git = {
    enable = true;
    userName = "Caleb Hess";
    userEmail = "redchess64@gmail.com";
    extraConfig = {
      core.askPass = "";
    };
  };

  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    bell.duration = 500;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  home.shellAliases = {
    l = "ls -lAh";
    "nrs" = "sudo nixos-rebuild switch";
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
    '';
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      set editing-mode vi
      set show-mode-in-prompt on
      set vi-ins-mode-string (ins)\1\e[5 q\2
      set vi-cmd-mode-string (cmd)\1\e[1 q\2
      set completion-ignore-case On
    '';
  };

  programs.bat.enable = true;
  programs.btop.enable = true;

  programs.direnv = {
    enable = true;
  };

  services.polybar = {
    enable = true;
    script = ''
      polybar-msg cmd quit 
      echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
      polybar -c ~/.config/polybar/config.ini default 2>&1 | tee -a /tmp/polybar1.log & disown
    '';
  };

  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
    settings = {
      corner-radius = 10;
    };
  };

  catppuccin.enable = true;

  programs.hyprlock.enable = true;
  programs.hyprlock.catppuccin.enable = false;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
