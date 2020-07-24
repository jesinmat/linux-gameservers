#!/bin/bash

# Get current IP and remove trailing space
IP=$(hostname -I | xargs)
run_as_user "sed -i 's/server-ip=/server-ip=$IP/' \"$GAMEDIR/serverfiles/server.properties\""

# Set server admin (OP)
if [ -z "$GAME_ADMIN" ]; then
    read -p "Server admin username (your username): " GAME_ADMIN || GAME_ADMIN=''
    echo
fi
run_as_user "echo \"$GAME_ADMIN\" > \"$GAMEDIR/serverfiles/ops.txt\""

# Set server MoTD (Displayed name)
if [ -z "$GAME_SERVER_NAME" ]; then
    read -p "Server name (MoTD): " GAME_SERVER_NAME || GAME_SERVER_NAME='A Minecraft Server'
    echo
fi
run_as_user "sed -i 's/motd=.*/motd=${GAME_SERVER_NAME//\//\\/}/' \"$GAMEDIR/serverfiles/server.properties\""
