{ pkgs, ... }:

let
  script = ./failsafe.sh;
in
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  environment.systemPackages = with pkgs; [
    git
    nodejs
    vim
  ];
  services.vscode-server.enable = true;
  systemd.user.services.auto-fix-vscode-server.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * root . /etc/profile; ${script} >> /tmp/cron.log 2>&1"
    ];
  };
}