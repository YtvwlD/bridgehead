#!/bin/bash -e

source lib/functions.sh

exitIfNotRoot

if [ $# -eq 0 ]; then
    log "ERROR" "Please provide a Project as argument"
    exit 1
fi

if [ $1 != "ccp" ] && [ $1 != "nngm" ] && [ $1 != "bbmri" ]; then
    log "ERROR" "Please provide a supported project like ccp, bbmri or nngm"
    exit 1
fi

export PROJECT=$1

checkRequirements

log "INFO" "Allowing the bridgehead user to start/stop the bridgehead."

cat <<EOF > /etc/sudoers.d/bridgehead-"${PROJECT}"
# This has been added by the Bridgehead installer. Remove with bridgehead uninstall.
Cmnd_Alias BRIDGEHEAD${PROJECT^^} = \\
    /bin/systemctl start bridgehead@${PROJECT}.service, \\
    /bin/systemctl stop bridgehead@${PROJECT}.service, \\
    /bin/systemctl restart bridgehead@${PROJECT}.service, \\
    /bin/systemctl restart bridgehead@*.service, \\
    /bin/chown -R bridgehead /etc/bridgehead /srv/docker/bridgehead, \\
    /usr/bin/chown -R bridgehead /etc/bridgehead /srv/docker/bridgehead

bridgehead ALL= NOPASSWD: BRIDGEHEAD${PROJECT^^}
EOF

# TODO: Determine wether this should be located in setup-bridgehead (triggered through bridgehead install) or in update bridgehead (triggered every hour)
if [ -z "$LDM_PASSWORD" ]; then
  log "INFO" "Now generating a password for the local data management. Please save the password for your ETL process!"
  generated_passwd="$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 32)"

  log "INFO" "Your generated credentials are:\n            user: $PROJECT\n            password: $generated_passwd"
  echo -e "## Local Data Management Basic Authentication\n# User: $PROJECT\nLDM_PASSWORD=$generated_passwd" >> /etc/bridgehead/${PROJECT}.local.conf;
fi

log "INFO" "Register system units for bridgehead and bridgehead-update"
cp -v \
    lib/systemd/bridgehead\@.service \
    lib/systemd/bridgehead-update\@.service \
    lib/systemd/bridgehead-update\@.timer \
    /etc/systemd/system/

systemctl daemon-reload

log INFO "Trying to update your bridgehead ..."

systemctl start bridgehead-update@"${PROJECT}".service

log "INFO" "Enabling autostart of bridgehead@${PROJECT}.service"
systemctl enable bridgehead@"${PROJECT}".service

log "INFO" "Enabling auto-updates for bridgehead@${PROJECT}.service ..."
systemctl enable --now bridgehead-update@"${PROJECT}".timer

log "INFO" "\nSuccess - now start your bridgehead by running\n            systemctl start bridgehead@${PROJECT}.service\n          or by rebooting your machine."
