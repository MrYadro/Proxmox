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
  mc
msg_ok "Installed Dependencies"

msg_info "Installing CastSponsorSkip"
echo 'deb [trusted=yes] https://apt.gabe565.com /' | sudo tee /etc/apt/sources.list.d/gabe565.list
$STD apt update
$STD sudo apt install castsponsorskip
msg_ok "Installed CastSponsorSkip"

msg_info "Creating Service"
$STD systemctl enable --now castsponsorskip.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
