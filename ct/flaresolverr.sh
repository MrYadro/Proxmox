#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/MrYadro/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck
# Co-Author: MrYadro
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE
# Source: https://github.com/FlareSolverr/FlareSolverr


function header_info {
clear
cat <<"EOF"
    ________               _____       __                    
   / ____/ /___ _________ / ___/____  / /   _____  __________
  / /_  / / __ `/ ___/ _ \\__ \/ __ \/ / | / / _ \/ ___/ ___/
 / __/ / / /_/ / /  /  __/__/ / /_/ / /| |/ /  __/ /  / /    
/_/   /_/\__,_/_/   \___/____/\____/_/ |___/\___/_/  /_/     
                                                             
EOF
}
header_info
echo -e "Loading..."
APP="FlareSolverr"
var_disk="4"
var_cpu="1"
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
echo -e "${APP} should be reachable by using the following URL.
         ${BL}http://${IP}:8191${CL}\n"
