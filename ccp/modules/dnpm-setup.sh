#!/bin/bash

if [ -n "${ENABLE_DNPM}" ]; then
	log INFO "DNPM setup detected (Beam.Connect) -- will start Beam.Connect for DNPM."
	OVERRIDE+=" -f ./$PROJECT/modules/dnpm-compose.yml"

	# Set variables required for Beam-Connect
	DNPM_APPLICATION_SECRET="$(echo \"This is a salt string to generate one consistent password. It is not required to be secret.\" | openssl rsautl -sign -inkey /etc/bridgehead/pki/${SITE_ID}.priv.pem | base64 | head -c 30)"
	DNPM_BEAM_SECRET_SHORT="$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20)"
fi
