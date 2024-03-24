#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck
# Co-Author: MrYadro
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE
# Source: https://github.com/recyclarr/recyclarr


function header_info {
clear
cat <<"EOF"
    ____                       __               
   / __ \___  _______  _______/ /___ ___________
  / /_/ / _ \/ ___/ / / / ___/ / __ `/ ___/ ___/
 / _, _/  __/ /__/ /_/ / /__/ / /_/ / /  / /    
/_/ |_|\___/\___/\__, /\___/_/\__,_/_/  /_/     
                /____/

EOF
}
header_info
echo -e "Loading..."
APP="Recyclarr"
var_disk="4"
var_cpu="2"
var_ram="1024"
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
header_info
if [[ ! -f /usr/local/bin/recyclarr ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating $APP LXC"
wget -q https://github.com/recyclarr/recyclarr/releases/latest/download/recyclarr-linux-x64.tar.xz
tar xJ --overwrite -C /usr/local/bin
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated $APP LXC"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
