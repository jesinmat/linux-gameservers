#!/bin/bash

CONFIG_PATH=$(sudo -u gameuser $GAMEDIR/${GAME}server details | grep "Config file:" | grep -o "/.*")

# Set server name (Displayed name)
if [ -z "$GAME_SERVER_NAME" ]; then
    read -p "Server name: " -e -i $(hostname) GAME_SERVER_NAME || GAME_SERVER_NAME='EcoTurnkeyGSM'
    echo
fi
run_as_user "sed -i 's/PublicName=.*/PublicName=${GAME_SERVER_NAME}/' \"$CONFIG_PATH\""

# Set server Password
if [ -z "$GAME_SERVER_PASS" ]; then
    read -p "Server password: " GAME_SERVER_PASS || GAME_SERVER_PASS=''
    echo
fi
run_as_user "sed -i 's/Password=.*/Password=${GAME_SERVER_PASS}/' \"$CONFIG_PATH\""

# Set server Public
if [ -z "$GAME_SERVER_PUBLIC" ]; then
    until [[ "$GAME_SERVER_PUBLIC" == "true" || "$GAME_SERVER_PUBLIC" == "false" ]]; do
        read -p "Set server public (true|false): " -e -i 'true' GAME_SERVER_PUBLIC
        echo
    done
fi
run_as_user "sed -i 's/Public=.*/Public=${GAME_SERVER_PUBLIC}/' \"$CONFIG_PATH\""

# Enable UPnP
if [ -z "$GAME_SERVER_UPNP" ]; then
    until [[ "$GAME_SERVER_UPNP" == "true" || "$GAME_SERVER_UPNP" == "false" ]]; do
        read -p "Enable UPnP (true|false): " -e -i 'true' GAME_SERVER_UPNP
        echo
    done
fi
run_as_user "sed -i 's/UPnP=.*/UPnP=${GAME_SERVER_PUBLIC}/' \"$CONFIG_PATH\""

# Set RCON password
if [ -z "$GAME_RCON_PASS" ]; then
    read -s -p "Set RCON password: " GAME_RCON_PASS || GAME_RCON_PASS='error'
    echo
fi
run_as_user "sed -i 's/RCONPassword=.*/RCONPassword=${GAME_RCON_PASS}/' \"$CONFIG_PATH\""
