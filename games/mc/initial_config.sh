#!/bin/bash
# Get current IP and remove trailing space
IP=$(hostname -I | xargs)
export IP
runuser -l $GAMEUSER -c 'sed -i "s/server-ip=/server-ip='"$IP"'/" '"$GAMEDIR"'/serverfiles/server.properties'
