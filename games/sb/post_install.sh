#!/bin/bash

GAME_CONFIG="$GAMEDIR/serverfiles/storage/starbound_server.config"

# Set server name (Displayed name)
if [ -z "$GAME_SERVER_NAME" ]; then
    read -p "Server name: " -e -i $(hostname) GAME_SERVER_NAME || GAME_SERVER_NAME='SBTurnkeyGSM'
    echo
fi
run_as_user "sed -i 's/\"serverName\" : .*/\"serverName\" : \"${GAME_SERVER_NAME}\",/' \"$GAME_CONFIG\""

# Set server Public (Steam)
if [ -z "$GAME_SERVER_PUBLIC" ]; then
    until [[ "$GAME_SERVER_PUBLIC" == "true" || "$GAME_SERVER_PUBLIC" == "false" ]]; do
        read -p "Server public (true|false): " -e -i 'true' GAME_SERVER_PUBLIC
        echo
    done
fi
run_as_user "sed -i 's/\"clientP2PJoinable\" : .*/\"clientP2PJoinable\" : ${GAME_SERVER_PUBLIC},/' \"$GAME_CONFIG\""

# Allow server acces with direct ip
run_as_user "sed -i 's/\"clientIPJoinable\" : .*/\"clientIPJoinable\" : true,/' \"$GAME_CONFIG\""

# Set RCON password
if [ -z "$GAME_RCON_PASS" ]; then
    read -s -p "Set RCON password: " GAME_RCON_PASS || GAME_RCON_PASS='error'
    echo
fi
run_as_user "sed -i 's/\"rconServerPassword\" : .*/\"rconServerPassword\" : \"${GAME_RCON_PASS}\",/' \"$GAME_CONFIG\""
