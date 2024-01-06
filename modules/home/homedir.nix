{ lib, config, ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  _.persist.directories = map (lib.removePrefix "${config.home.homeDirectory}/") (with config.xdg.userDirs; [
    desktop
    documents
    download
    music
    pictures
    publicShare
    templates
    videos
  ]);
}
