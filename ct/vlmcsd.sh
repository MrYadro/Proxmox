#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/MrYadro/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
  clear
  cat <<"EOF"
        __                        __
 _   __/ /___ ___  ______________/ /
| | / / / __ `__ \/ ___/ ___/ __  / 
| |/ / / / / / / / /__(__  ) /_/ /  
|___/_/_/ /_/ /_/\___/____/\__,_/   
                                                             
EOF
}
header_info
echo -e "Loading..."
APP="vlmcsd"
var_disk="6"
var_cpu="4"
var_ram="4096"
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
  if [[ ! -d /etc/vlmcsd/ ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
$STD git clone --branch master --single-branch https://github.com/Wind4/vlmcsd.git
cd vlmcsd
$STD make
mv bin/vlmcs /usr/bin
mv bin/vlmcsd /usr/bin
mv etc/vlmcsd.ini /usr/share/vlmcsd
mv etc/vlmcsd.kmd /usr/share/vlmcsd
chmod +x bin/vlmcs
chmod +x bin/vlmcsd
}

start
build_container
description

msg_info "Setting Container to Normal Resources"
pct set $CTID -memory 512
pct set $CTID -cores 1
msg_ok "Set Container to Normal Resources"
msg_ok "Completed Successfully!\n"
