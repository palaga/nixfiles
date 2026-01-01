{ pkgs, ... }:

{
  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

    image = pkgs.fetchurl {
      url = "https://getwallpapers.com/wallpaper/full/9/2/7/430776.jpg";
      hash = "sha256-4tm1YvLyu/JqSrlN+GwqBHLkr3LMwHcw+DKvA+WO0v8=";
    };

    fonts = {
      sizes = {
        desktop = 10;
        applications = 10;
        popups = 10;
        terminal = 10;
      };

      serif.name = "Serif";

      sansSerif = {
        package = pkgs.nerd-fonts.ubuntu-sans;
        name = "Ubuntu Regular";
      };

      monospace = {
        package = pkgs.nerd-fonts.ubuntu-mono;
        name = "Ubuntu Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    polarity = "dark";  # Force dark-mode

    targets.plymouth.enable = false;
  };
}
