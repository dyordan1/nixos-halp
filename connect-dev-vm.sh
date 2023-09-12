#!/bin/bash

# Run create-dev-vm.sh to create a new Dev VM (one-time setup).
#
# Set this script in your ~/.ssh/config, e.g.
# Host "Dev VM"
#   User some_user
#   ProxyCommand /path/to/connect-dev-vm.sh
#   ForwardAgent yes
#   ConnectTimeout 60
#
# Extend VS Code connect timeout to 60:
# Cmd+Shift+P > Remote-SSH: Settings > Remote.SSH: Connect Timeout

INSTANCE=$USER-dev-vm

INSTANCE_INFO=$(gcloud compute instances list --filter="name=$INSTANCE" --format json)
STATUS=$(echo "$INSTANCE_INFO" | jq -r '.[0].status')
IP=$(echo "$INSTANCE_INFO" | jq -r '.[0].networkInterfaces[0].accessConfigs[0].natIP')

if [ "$STATUS" = "TERMINATED" ]; then
    gcloud compute instances start $INSTANCE --zone=us-central1-a
elif [ "$STATUS" != "RUNNING" ]; then
    echo "Unknown Status $STATUS"
fi

until /usr/bin/nc -G 1 -z $IP 22; do
    sleep 1
done

/usr/bin/nc $IP 22
