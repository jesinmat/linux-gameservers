#!/bin/bash

# Set steam username
if [ -z "$GAME_STEAM_USER" ]; then
    echo "|----------------STEAM ACCOUNT NOTICE----------------"
    echo "|Starbound does not support anonymous login."
    echo "|LinuxGSM recommends using a created steam account specifically for hosting."
    echo "|Starbound recommends not entering your password"
    echo "|LinuxGSM does not support well handling the password input, the installation screen will be waiting for input without a prompt."
    echo "|Account credentials are not validated by LinuxGSM"
    echo "|Starbound will need credentials on each application update"
    echo "|Modified config: $GAMEDIR/lgsm/config-lgsm/sbserver/common.cfg"
    echo ""

    read -p "Steam username: "  GAME_STEAM_USER || GAME_STEAM_USER='error'
fi
run_as_user "echo steamuser=$GAME_STEAM_USER >> \"$GAMEDIR/lgsm/config-lgsm/sbserver/common.cfg\""

# Set steam password
if [ -z "$GAME_STEAM_PASS" ]; then
    echo "2FA - Steam Guard: https://docs.linuxgsm.com/steamcmd#plain-text-passwords"
    read -s -p "Steam password: "  GAME_STEAM_PASS || GAME_STEAM_PASS=''
fi
run_as_user "echo steampass=$GAME_STEAM_PASS >> \"$GAMEDIR/lgsm/config-lgsm/sbserver/common.cfg\""
