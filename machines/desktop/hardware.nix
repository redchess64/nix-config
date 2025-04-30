{config, ...}: {
  imports = [
    ./generated-hardware.nix
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
    };
    kernelModules = ["kvm-amd"];
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

  services.xserver.videoDrivers = ["nvidia"];

  networking = {
    useDHCP = false;
    hostName = "desktop";
    defaultGateway = "192.168.10.1";
    interfaces.enp5s0.ipv4.addresses = [
      {
        address = "192.168.10.80";
        prefixLength = 24;
      }
    ];
  };
}
