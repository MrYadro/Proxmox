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
  git \
  make \
  build-essential \
  curl \
  sudo \
  mc
msg_ok "Installed Dependencies"

msg_info "Building vlmcsd (Patience)"
$STD git clone --branch master --single-branch https://github.com/Wind4/vlmcsd.git
cd vlmcsd
$STD make
msg_ok "Built vlmcsd"

msg_info "Installing vlmcsd"
mkdir -p /etc/vlmcsd/
mv bin/vlmcs /usr/bin
mv bin/vlmcsd /usr/bin
mv etc/vlmcsd.ini /etc/vlmcsd
mv etc/vlmcsd.kmd /etc/vlmcsd
chmod +x /usr/bin/vlmcs
chmod +x /usr/bin/vlmcsd
msg_info "Installed vlmcsd"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/vlmcsd.service
[Unit]
Description=Vlmcsd (KMS Emulator in C)
After=network.target

[Service]
Type=simple
User=nobody
Group=nogroup
ExecStart=/usr/bin/vlmcsd -i /etc/vlmcsd/vlmcsd.ini -D

[Install]
WantedBy=multi-user.target
EOF
$STD systemctl enable --now vlmcsd.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
