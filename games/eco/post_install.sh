#!/bin/bash

# Set server Description (Displayed name)
if [ -z "$GAME_SERVER_NAME" ]; then
    read -p "Server description: " -e -i $(hostname) GAME_SERVER_NAME || GAME_SERVER_NAME='EcoTurnkeyGSM'
    echo
fi
run_as_user "sed -i 's/\"Description\":.*/\"Description\": \"${GAME_SERVER_NAME}\",/' \"$GAMEDIR/serverfiles/Configs/Network.eco\""

# Set server Password
if [ -z "$GAME_SERVER_PASS" ]; then
    read -p "Server password: " GAME_SERVER_PASS || GAME_SERVER_PASS=''
    echo
fi
run_as_user "sed -i 's/\"Password\":.*/\"Password\": \"${GAME_SERVER_PASS}\",/' \"$GAMEDIR/serverfiles/Configs/Network.eco\""

# Set server Public
if [ -z "$GAME_SERVER_PUBLIC" ]; then
    until [[ "$GAME_SERVER_PUBLIC" == "true" || "$GAME_SERVER_PUBLIC" == "false" ]]; do
        read -p "Server public (true|false): " -e -i 'true' GAME_SERVER_PUBLIC
        echo
    done
fi
run_as_user "sed -i 's/\"PublicServer\":.*/\"PublicServer\": ${GAME_SERVER_PUBLIC},/' \"$GAMEDIR/serverfiles/Configs/Network.eco\""

# Set server UPnP
if [ -z "$GAME_SERVER_UPNP" ]; then
    until [[ "$GAME_SERVER_UPNP" == "true" || "$GAME_SERVER_UPNP" == "false" ]]; do
        read -p "Server enable UPnP (true|false): " -e -i 'true' GAME_SERVER_UPNP
        echo
    done
fi
run_as_user "sed -i 's/\"UPnPEnabled\":.*/\"UPnPEnabled\": ${GAME_SERVER_UPNP}/' \"$GAMEDIR/serverfiles/Configs/Network.eco\""
