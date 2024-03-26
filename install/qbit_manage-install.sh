#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

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

msg_info "Updating Python3"
$STD apt-get install -y \
  python3 \
  python3-dev \
  python3-pip
msg_ok "Updated Python3"

msg_info "Installing qbit_manage"
mkdir -p /var/lib/qbit_manage/
RELEASE=$(wget -q https://github.com/StuffAnThings/qbit_manage/releases/latest -O - | grep "title>Release" | cut -d " " -f 4)
wget -q https://github.com/StuffAnThings/qbit_manage/archive/refs/tags/$RELEASE.zip
unzip -qq $RELEASE -d /opt/qbit_manage
chmod 775 /opt/qbit_manage /var/lib/qbit_manage/
python3 -m pip install -q -r /opt/qbit_manage/requirements.txt
cp config/config.yml.sample config/config.yml
msg_ok "Installed qbit_manage"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/qbit_manage.service
[Unit]
Description=qbit_manage Daemon
After=syslog.target network.target

[Service]
WorkingDirectory=/opt/qbit_manage/
UMask=0002
Restart=on-failure
RestartSec=5
Type=simple
ExecStart=/usr/bin/python3 /opt/qbit_manage/qbit_manage.py
KillSignal=SIGINT
TimeoutStopSec=20
SyslogIdentifier=qbit_manage

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now qbit_manage
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
rm -rf $RELEASE.zip
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"