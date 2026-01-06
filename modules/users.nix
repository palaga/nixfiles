{ pkgs, ... }:

{
  users.users.chris = {
    isNormalUser = true;
    description = "Chris";
    extraGroups = [ "networkmanager" "wheel" "incus-admin" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  home-manager.users.chris = import ./home.nix;
}
