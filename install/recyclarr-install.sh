#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck
# Co-Author: MrYadro
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE
# Source: https://github.com/recyclarr/recyclarr

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
msg_ok "Installed Dependencies"

msg_info "Installing Recyclarr"
wget -q https://github.com/recyclarr/recyclarr/releases/latest/download/recyclarr-linux-x64.tar.xz
tar -xf recyclarr-linux-x64.tar.xz --overwrite -C /usr/local/bin
chmod 775 /usr/local/bin/recyclarr
msg_ok "Installed Recyclarr"

motd_ssh
customize

msg_info "Cleaning up"
rm -rf recyclarr-linux-x64.tar.xz
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"