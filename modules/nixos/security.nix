{
  security.doas = {
    enable = true;
    extraRules = [
      { groups = [ "wheel" ]; persist = true; setEnv = [ "NIX_PATH" ]; }
    ];
  };
  security.sudo.enable = false;
}
