#!/bin/bash

GAMEUSER="${GAME}user"
GAMESERVER="${GAME}server"
export GAMEUSER
export GAMESERVER

function fail {
    printf '%s\n' "$1" >&2
    exit 1
}

function run_game_script {
    local SCRIPT="games/$GAME/$1"
    if [ -f "$SCRIPT" ] ; then
        chmod +x "$SCRIPT"
        bash "$SCRIPT"
    fi
}

function set_steam_credentials {
    echo "Setting Steam credentials"
    # TODO Set steam credentials
}

function install_gamedig {
    curl -sL https://deb.nodesource.com/setup_14.x | bash -
    apt install -y nodejs
    npm install gamedig -g
    runuser -l "$GAMEUSER" -c 'mkdir gamedig'
    cp "games/$GAME/gamedig_config.sh" "/home/$GAMEUSER/gamedig/"
    chown $GAMEUSER:$GAMEUSER "/home/$GAMEUSER/gamedig/gamedig_config.sh"
}

[ -d "games/$GAME" ] || fail "This game is not supported!"

run_game_script "install_dependencies.sh"

# useradd -m -s /bin/bash "$GAMEUSER"
# # Generate random password
# PASS="$GAMEUSER"
# echo "$GAMEUSER:$PASS" | chpasswd

runuser -l "$GAMEUSER" -c 'wget -O linuxgsm.sh https://linuxgsm.sh'
runuser -l "$GAMEUSER" -c 'chmod +x linuxgsm.sh'
runuser -l "$GAMEUSER" -c 'bash linuxgsm.sh '"$GAMESERVER"''

[ -n "$STEAM_ACC_REQUIRED" ] && set_steam_credentials

runuser -l $GAMEUSER -c './'"$GAMESERVER"' auto-install'

run_game_script "initial_config.sh"

[ -f "games/$GAME/gamedig_config.sh" ] && install_gamedig
