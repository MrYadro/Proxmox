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
         __    _ __                                            
  ____ _/ /_  (_) /_     ____ ___  ____ _____  ____ _____ ____ 
 / __ `/ __ \/ / __/    / __ `__ \/ __ `/ __ \/ __ `/ __ `/ _ \
/ /_/ / /_/ / / /_     / / / / / / /_/ / / / / /_/ / /_/ /  __/
\__, /_.___/_/\__/____/_/ /_/ /_/\__,_/_/ /_/\__,_/\__, /\___/ 
  /_/           /_____/                           /____/       

EOF
}
header_info
echo -e "Loading..."
APP="qbit-manage"
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
if [[ ! -d /var/lib/qbit_manage/ ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
RELEASE=$(wget -q https://github.com/StuffAnThings/qbit_manage/releases/latest -O - | grep "title>Release" | cut -d " " -f 4)
wget -q https://github.com/StuffAnThings/qbit_manage/archive/refs/tags/$RELEASE.zip
unzip -qq $RELEASE -d /opt
mv /opt/qbit_manage-${RELEASE:1} /opt/qbit_manage
chmod 775 /opt/qbit_manage /var/lib/qbit_manage/
python3 -m pip install -q -r /opt/qbit_manage/requirements.txt
msg_info "Updating $APP LXC"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated $APP LXC"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
