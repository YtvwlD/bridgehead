#!/bin/bash


## Check if user is a su
echo "Welcome to the starting a bridgehead. We will get your instance up and running in no time"
echo "First we will check if all prerequisites are met ..."
prerequisites="git docker docker-compose"
for prerequisite in $prerequisites; do
  $prerequisite --version 2>&1
  is_available=$?
  if [ $is_available -gt 0 ]; then
    log "ERROR" "Prerequisite not fulfilled - $prerequisite is not available!"
    exit 79
  fi
  # TODO: Check for specific version
done

echo "Checking /etc/bridgehead/"

## Download submodule
if [ ! -d "/etc/bridgehead/" ]; then
  echo "Please set up the config folder. Instruction are in the readme."
  exit 1
else
  echo "Done"
fi

echo "Checking /etc/bridgehead/site.conf"

#check if site.conf is created
if [ ! -f /etc/bridgehead/site.conf ]; then
  echo "Please create your specific site.conf file from the site.dev.conf"
  exit 1
else
  echo "Done"
fi

#Load site specific variables
source /etc/bridgehead/site.conf

if [ -z "$site_name" ]; then
  echo "Please set site_name"
  exit 1
fi

echo "Checking project config"

#check if project env is present
if [ -d "/etc/bridgehead/${project}.env" ]; then
   echo "Please copy the tempalte from ${project} and put it in the /etc/bridgehead-config/ folder"
   exit 1
else 
  echo "Done"
fi

echo "Checking ssl cert"

## Create SSL Cert
if [ ! -d "/certs" ]; then
  echo "SSL cert missing, now we create one. Please consider getting a signed one"
  mkdir certs
fi

if [ -d "/etc/bridgehead/traefik.crt" ]; then
  openssl req -x509 -newkey rsa:4096 -nodes -keyout certs/traefik.key -out certs/traefik.crt -days 365
fi

echo "All prerequisites are met!"
