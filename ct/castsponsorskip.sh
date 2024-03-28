#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/MrYadro/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
  clear
  cat <<"EOF"
   ______           __  _____                                   _____ __   _     
  / ____/___ ______/ /_/ ___/____  ____  ____  _________  _____/ ___// /__(_)___ 
 / /   / __ `/ ___/ __/\__ \/ __ \/ __ \/ __ \/ ___/ __ \/ ___/\__ \/ //_/ / __ \
/ /___/ /_/ (__  ) /_ ___/ / /_/ / /_/ / / / (__  ) /_/ / /   ___/ / ,< / / /_/ /
\____/\__,_/____/\__//____/ .___/\____/_/ /_/____/\____/_/   /____/_/|_/_/ .___/ 
                         /_/                                            /_/                                                           
EOF
}
header_info
echo -e "Loading..."
APP="CastSponsorSkip"
var_disk="1"
var_cpu="1"
var_ram="512"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
  if [[ ! -f /etc/systemd/system/castsponsorskip.service ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
$STD apt-get update &>/dev/null
$STD apt-get -y upgrade &>/dev/null
}

start
build_container
description

msg_ok "Set Container to Normal Resources"
msg_ok "Completed Successfully!\n"
