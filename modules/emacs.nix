{ config, lib, pkgs, ... }:

{
  services.emacs.enable = true;

  # Required for doom emacs to work properly (further configured by home manager).
  environment.sessionVariables = {
    DOOMLOCALDIR = "$HOME/.local/share/doomemacs";
    DOOMPROFILELOADFILE = "$HOME/.local/share/doomemacs/profiles/load.el";
  };

}
