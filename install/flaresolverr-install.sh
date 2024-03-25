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
$STD apt-get install -y --no-install-recommends chromium
$STD apt-get install -y --no-install-recommends chromium-common
$STD apt-get install -y --no-install-recommends chromium-driver
$STD apt-get install -y xvfb
$STD apt-get install -y mc
msg_ok "Installed Dependencies"

msg_info "Installing FlareSolverr"
RELEASE=$(wget -q https://github.com/FlareSolverr/FlareSolverr/releases/latest -O - | grep "title>Release" | cut -d " " -f 4)
wget -q https://github.com/FlareSolverr/FlareSolverr/releases/download/$RELEASE/flaresolverr_linux_x64.tar.gz
tar -xzf flaresolverr_linux_x64.tar.gz -C /opt
msg_ok "Installed FlareSolverr"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/flaresolverr.service
[Unit]
Description=FlareSolverr
After=network.target
[Service]
SyslogIdentifier=flaresolverr
Restart=always
RestartSec=5
Type=simple
Environment="LOG_LEVEL=info"
Environment="CAPTCHA_SOLVER=none"
WorkingDirectory=/opt/flaresolverr
ExecStart=/opt/flaresolverr/flaresolverr
TimeoutStopSec=30
[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now flaresolverr.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
rm flaresolverr_linux_x64.tar.gz
rm -rf /var/lib/apt/lists/*
rm -f /usr/lib/x86_64-linux-gnu/libmfxhw*
rm -f /usr/lib/x86_64-linux-gnu/mfx/*
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"