#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/MrYadro/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# Co-Author: MrYadro
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
                                                      __
  ______________  __________      ________  ___  ____/ /
 / ___/ ___/ __ \/ ___/ ___/_____/ ___/ _ \/ _ \/ __  / 
/ /__/ /  / /_/ (__  |__  )_____(__  )  __/  __/ /_/ /  
\___/_/   \____/____/____/     /____/\___/\___/\__,_/   
                                                        
EOF
}
header_info
echo -e "Loading..."
APP="cross-seed"
var_disk="2"
var_cpu="2"
var_ram="1024"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="0"
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
if [[ ! -f cross-seed ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating cross-seed LXC"
npm update -g
msg_ok "Updated cross-seed LXC"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
