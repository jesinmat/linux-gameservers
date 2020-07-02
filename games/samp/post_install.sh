#!/bin/bash
if [ -z "$GAME_RCON_PASS" ]; then
    read -ps "Set RCON password:" GAME_RCON_PASS || GAME_RCON_PASS=`mcookie`
fi
run_as_user 'sed -i "s/rcon_password changeme/rcon_password '"$GAME_RCON_PASS"'/" '"$GAMEDIR"'/serverfiles/samp03/server.cfg'
