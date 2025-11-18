let
  getName = let
    parse = drv: (builtins.parseDrvName drv).name;
  in
    x:
      if builtins.isString x
      then parse x
      else x.pname or (parse x.name);
in {
  config.allowUnfreePredicate = pkg:
    builtins.elem (getName pkg) [
      "vesktop"
      "steam"
      "steam-unwrapped"
      "aseprite"
      "spotify"
      "nvidia-x11"
      "nvidia-settings"
      "cups-brother-hll2340dw"
    ];
}
