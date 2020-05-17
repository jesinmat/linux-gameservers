#!/bin/bash
# TODO random password
PASS="randompass"
runuser -l $GAMEUSER -c 'sed -i "s/rcon_password changeme/rcon_password '"$PASS"'/" '"$GAMEDIR"'/serverfiles/samp03/server.cfg'
