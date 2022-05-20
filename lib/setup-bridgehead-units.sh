#!/bin/bash

source lib/functions.sh

exitIfNotRoot

if [ $# -eq 0 ]; then
    log "ERROR" "Please provide a Project as argument"
    exit 1
fi

if [ $1 != "ccp" ] && [ $1 != "nngm" ] && [ $1 != "gbn" ]; then
    log "ERROR" "Please provide a supported project like ccp, gbn or nngm"
    exit 1
fi

export PROJECT=$1

checkRequirements

log "INFO" "Register system units for bridgehead and bridgehead-update"
cp -v \
    lib/systemd/bridgehead\@.service \
    lib/systemd/bridgehead-update\@.service \
    lib/systemd/bridgehead-update\@.timer \
    /etc/systemd/system/

systemctl daemon-reload

if ! systemctl is-active --quiet bridgehead@"${PROJECT}"; then
    log "INFO" "Enabling autostart of bridgehead@${PROJECT}.service"
    systemctl enable bridgehead@"${PROJECT}"
    log "INFO" "Enabling nightly updates for bridgehead@${PROJECT}.service ..."
    systemctl enable --now bridgehead-update@"${PROJECT}".timer
fi

log "INFO" "\nDone - now start your bridgehead by running\n\tsystemctl start bridgehead@${PROJECT}.service\nor by rebooting your machine."
