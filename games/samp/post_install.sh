#!/bin/bash

# Set RCON password
if [ -z "$GAME_RCON_PASS" ]; then
    read -s -p "Set RCON password: " GAME_RCON_PASS || GAME_RCON_PASS=`mcookie`
    echo
fi
run_as_user 'sed -i "s/rcon_password changeme/rcon_password '"$GAME_RCON_PASS"'/" '"$GAMEDIR"'/serverfiles/samp03/server.cfg'

# Set server Host name
if [ -z "$GAME_SERVER_NAME" ]; then
    read -p "Set HostName (displayed name): " GAME_SERVER_NAME || GAME_SERVER_NAME='SA-MP 3.0 Server'
    echo
fi
run_as_user 'sed -i "s/^hostname .*/hostname '"${GAME_SERVER_NAME//\//\\/}"'/" '"$GAMEDIR"'/serverfiles/samp03/server.cfg'
