{...}: {
  imports = [
    ./generated-hardware.nix
    ./configuration.nix
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
    };
    kernelModules = ["kvm-amd"];
  };
}
