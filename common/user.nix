{
  pkgs,
  inputs,
  ...
}: {
  users.users.calebh.packages = with pkgs; [
    # Desktop applications
    vesktop
    aseprite
    prismlauncher
    nemo
    nautilus
    kdePackages.kate
    element-desktop
    drawing
    alacritty
    inputs.pkgs-unstable.olympus

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
    bat
    btop
    ripgrep
    nh

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
    inputs.pkgs-unstable.quickshell

    # Other
    # nerdfonts.droid-sans-mono
    wev
    lm_sensors
    catppuccin-cursors.mochaDark
  ];
  nix-stow = {
    enable = true;
    users.calebh = {
      enable = true;
      package = ../configs;
    };
  };
}
