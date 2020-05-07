#!/bin/bash

function fail {
    printf '%s\n' "$1" >&2
    exit 1
}

if [ "$#" -lt 1 ]; then
    fail "Usage: $0 game_code"
fi

GAME="$1"
GAMEUSER="gameuser"
GAMESERVER="${GAME}server"
export GAMEUSER
export GAMESERVER

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
    if ! dpkg -s nodejs > /dev/null 2>&1; then
        curl -sL https://deb.nodesource.com/setup_14.x | bash -
        apt install -y nodejs
    fi
    npm install gamedig -g
}

function install_common_dependencies {
    apt update
    apt install mailutils postfix curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux
}

[ -d "games/$GAME" ] || fail "This game is not supported!"

# Install common dependencies
install_common_dependencies

# Install game dependencies
run_game_script "install_dependencies.sh"

# Download LinuxGSM and game server files
runuser -l "$GAMEUSER" -c 'wget -O linuxgsm.sh https://linuxgsm.sh'
runuser -l "$GAMEUSER" -c 'chmod +x linuxgsm.sh'
runuser -l "$GAMEUSER" -c 'bash linuxgsm.sh '"$GAMESERVER"''

[ -n "$STEAM_ACC_REQUIRED" ] && set_steam_credentials

# Install game server
runuser -l "$GAMEUSER" -c './'"$GAMESERVER"' auto-install'

# Apply default config, if needed
run_game_script "initial_config.sh"

# Install Gamedig for supported games
. "games/$GAME/game_properties.sh"
[ -n "$GAMEDIG_TYPE" ] && install_gamedig
