{ config, pkgs, pkgs-unstable, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "calebh";
  home.homeDirectory = "/home/calebh";

  home.file.".config/i3/config" = {
    source = ./configs/i3/config;
    recursive = true;   # link recursively
    executable = true;  # make all files executable
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

  home.packages = with pkgs; [
    neofetch
  ];

  programs.git = {
    enable = true;
    userName = "Caleb Hess";
    userEmail = "redchess64@gmail.com";
  };

  programs.alacritty.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # packages = pkgs-unstable.neovim-unwrapped;
  };

  programs.fish.enable = true;
  programs.bash.enable = true;
  programs.bash.shellAliases = {
    "nrs" = "sudo nixos-rebuild switch";
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

  services.flameshot.enable = true;

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
