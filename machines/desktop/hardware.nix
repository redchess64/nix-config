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
      version =  "570.181";
      sha256_64bit = "sha256-8G0lzj8YAupQetpLXcRrPCyLOFA9tvaPPvAWurjj3Pk=";
      sha256_aarch64 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      openSha256 = "sha256-U/uqAhf83W/mns/7b2cU26B7JRMoBfQ3V6HiYEI5J48=";
      settingsSha256 = "sha256-iBx/X3c+1NSNmG+11xvGyvxYSMbVprijpzySFeQVBzs=";
      persistencedSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
