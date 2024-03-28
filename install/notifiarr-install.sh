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

msg_info "Installing Notifiarr"
# $STD curl -s https://golift.io/repo.sh | $STD bash -s - notifiarr
  curl -sL https://packagecloud.io/golift/pkgs/gpgkey | apt-key add -
  curl -sL https://packagecloud.io/golift/unstable/gpgkey | apt-key add -
  echo "Creating /etc/apt/sources.list.d/golift.list ..."
  tee /etc/apt/sources.list.d/golift.list <<EOF
deb https://packagecloud.io/golift/pkgs/ubuntu focal main
EOF
  $STD apt-get update
  $STD apt-get install notifiarr

msg_ok "Installed Notifiarr"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
