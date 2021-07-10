#!/bin/bash

# Set server Name
if [ -z "$GAME_SERVER_NAME" ]; then
    read -p "Server description: " -e -i $(hostname) GAME_SERVER_NAME || GAME_SERVER_NAME='ValheimTurnkeyGSM'
    echo
fi
run_as_user "echo \"servername=\"$GAME_SERVER_NAME\"\" >> \"$GAMEDIR/lgsm/config-lgsm/vhserver/vhserver.cfg\""

# Set server Password
if [ -z "$GAME_SERVER_PASS" ]; then
    read -p "Server password (Minimum password length is 5.): " GAME_SERVER_PASS || GAME_SERVER_PASS=''
        echo
    until [[ "$GAME_SERVER_PASS" == '' || "${#GAME_SERVER_PASS}" -ge 5 ]]; do
        read -p "Server password (Minimum password length is 5.): " GAME_SERVER_PASS || GAME_SERVER_PASS=''
        echo
    done
fi
run_as_user "echo \"serverpassword=\"$GAME_SERVER_PASS\"\" >> \"$GAMEDIR/lgsm/config-lgsm/vhserver/vhserver.cfg\""

# Set server Public
if [ -z "$GAME_SERVER_PUBLIC" ]; then
    until [[ "$GAME_SERVER_PUBLIC" == "1" || "$GAME_SERVER_PUBLIC" == "0" ]]; do
        read -p "Server public (1|0): " -e -i '1' GAME_SERVER_PUBLIC
        echo
    done
fi
run_as_user "echo \"public=\"$GAME_SERVER_PUBLIC\"\" >> \"$GAMEDIR/lgsm/config-lgsm/vhserver/vhserver.cfg\""
