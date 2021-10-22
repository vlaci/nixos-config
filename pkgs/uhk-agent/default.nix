{ appimageTools, fetchurl }:

appimageTools.wrapType2 {
  name = "uhk-agent";
  src = fetchurl {
    url = "https://github.com/UltimateHackingKeyboard/agent/releases/download/v1.5.15/UHK.Agent-1.5.15-linux-x86_64.AppImage";
    sha256 = "sha256-t2Jwd/x0eTZ4xBaCb/FomH/zSRLt7IIERUF9n9ONCpE=";
  };
}
