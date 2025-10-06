{
  pkgs,
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
    catppuccin-cursors.mochaDark
  ];
}
