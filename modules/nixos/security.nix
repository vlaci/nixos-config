{
  security.doas = {
    enable = true;
    extraRules = [
      { groups = [ "wheel" ]; persist = true; keepEnv = true; }
    ];
  };
  security.sudo.enable = false;
}
