#!/bin/bash
# TODO random password
PASS="randompass"
[ -n "$APP_PASS" ] && PASS="$APP_PASS"
run_as_user 'sed -i "s/rcon_password changeme/rcon_password '"$PASS"'/" '"$GAMEDIR"'/serverfiles/samp03/server.cfg'
