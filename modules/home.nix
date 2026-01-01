{ pkgs, ... }: {
  home.stateVersion = "25.11";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.starship.enable = true;

  home.packages = with pkgs; [
    mg

    git

    jq
    fzf

    azure-cli

    google-chrome

    whatsapp-electron
    spotify

    # Work
    zulip
    slack
    teams-for-linux

    # Doom
    direnv
    ripgrep
    pandoc
    fd
    shellcheck
    opentofu
    nixfmt
    pipenv
    isort
    html-tidy
    gopls
    rust-analyzer

    # hyprland
    brightnessctl
    wlr-randr
    wdisplays
    wev
    wl-clipboard
  ];

  programs.obsidian = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
  };

  home.file.".emacs.d".source = pkgs.fetchFromGitHub {
    owner = "doomemacs";
    repo = "doomemacs";
    rev = "ead254e15269bf8564625df4c8d2af6690a0df49";
    hash = "sha256-R3I8NErGSCd6kSTUBNe7SNcRDUtJ1xl8zvD13C6SrRg=";
  };

  # TODO: Future work, for now, link config directly (see below).
  wayland.windowManager.hyprland = {
    enable = false;
    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, return, exec, $terminal"
      ];
    };
  };

  # TODO: Remove this in favor of pure nix config (see above).
  home.file.".config/hypr" = {
    enable = true;
    recursive = true;
    source = ../config/hypr;
  };

  programs.fuzzel.enable = true;

  # Disable hyprpanel configuration, so we can change transparency.
  stylix.targets.hyprpanel.enable = false;

  # TODO: doesn't seem to work properly
  programs.hyprpanel = {
    enable = true;
    settings = {
      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      layout = {
        bar.layouts = {
          "*" = {
            left = [ "dashboard" "workspaces" ];
            middle = [ "media" ];
            right = [ "volume" "systray" "notifications" ];
          };
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      theme.bar.transparent = true;

      theme.font = {
        name = "CaskaydiaCove NF";
        size = "16px";
      };
    };
  };

  programs.hyprlock.enable = true;
  programs.hyprshot.enable = true;
  services.hyprsunset.enable = true;
  services.hyprshell.enable = true;
  #services.hyprpaper.enable = true;
  services.swww.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.kitty.enable = true;

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "nixos-rebuild switch";
    };

    history.size = 10000;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" ];
    };
  };
}
