{config, ...}: {
  imports = [
    ./generated-hardware.nix
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
    };
  };

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.95.05";
      sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
      sha256_aarch64 = "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk=";
      openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
      settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
      persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
    };
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
