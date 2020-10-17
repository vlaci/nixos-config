{ lib, ... }:

lib.mkProfile "gui" {
  xsession = {
    enable = true;
    scriptPath = ".xsession-hm";
  };
}
