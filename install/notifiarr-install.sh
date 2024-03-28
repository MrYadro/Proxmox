#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get update
$STD apt-get -qqy install \
  curl \
  sudo \
  gpg \
  mc
msg_ok "Installed Dependencies"

msg_info "Installing Notifiarr Repository"
mkdir -p /etc/apt/keyrings
curl -fsSL https://packagecloud.io/golift/pkgs/gpgkey | gpg --dearmor -o /usr/share/keyrings/golift-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/golift-archive-keyring.gpg] https://packagecloud.io/golift/pkgs/ubuntu focal main" >/etc/apt/sources.list.d/golift.list
msg_ok "Installed Notifiarr Repository"

msg_info "Installing Notifiarr"
apt-get update &>/dev/null
apt-get install -y notifiarr &>/dev/null
msg_ok "Installed Notifiarr"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
