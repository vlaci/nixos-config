{ config, ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  _.persist.directories = with config.xdg.userDirs; [
    desktop
    documents
    download
    music
    pictures
    publicShare
    templates
    videos
  ];
}
