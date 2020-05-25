#!/bin/bash

function fail {
    printf '%s\n' "$1" >&2
    exit 1
}

function usage_format {
    printf "    %s\n        %s\n" "$1" "$2"
}

function usage {
    echo "Usage: $0 -g game_code -u username [ -p install_path ]"
    echo "Example: $0 -g mc -u john -p /home/john/gameserver"
    usage_format "-g, --game" "Select game to install. Argument must be one of the games located in ./games/ directory."
    usage_format "-u, --username" "Install game as selected user. User will be granted ownership of all game files. Root user not allowed."
    usage_format "-p, --path" "Installation path for server. Directory will be created if it doesn't exist. Default: /home/(username)/gameserver"
}

function install_common_dependencies {
    # Add support for 32bit apps
    dpkg --add-architecture i386
    apt update
    apt install -y mailutils postfix curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux
}

function validate_user {
    if ! getent passwd "$GAMEUSER" > /dev/null 2>&1; then
        fail "This user does not exist."
    elif [ $(id -u "$GAMEUSER") -eq 0 ]; then
        fail "Root user cannot run game servers. Please select another user."
    fi
}

function run_game_script {
    local SCRIPT="$SCRIPT_PATH/games/$GAME/$1"
    if [ -f "$SCRIPT" ] ; then
        chmod +x "$SCRIPT"
        . "$SCRIPT"
    fi
}

if [ "$#" -lt 1 ]; then
    usage
    exit 1
fi

SCRIPT_PATH=$(dirname $(realpath "$0"))
GAME=
GAMEUSER=

while [[ $# -gt 0 ]]; do
    case "$1" in
        -g|--game)
            GAME="$2"
            shift
            shift
        ;;
        -u|--user)
            GAMEUSER="$2"
            shift
            shift
        ;;
        -p|--path)
            GAMEDIR="$2"
            shift
            shift
        ;;
        *)    # unknown option
            fail "Illegal argument: $1. Run script without arguments to see usage."
        ;;
    esac
done

[ -z "$GAME" ] && fail "No game selected!"
[ -z "$GAMEUSER" ] && fail "No user selected!"
[ -z "$GAMEDIR" ] && GAMEDIR="/home/$GAMEUSER/gameserver"

validate_user

if [ ! -d "$GAMEDIR" ]; then
    mkdir -p "$GAMEDIR"
    chown $GAMEUSER: "$GAMEDIR"
fi

GAMESERVER="${GAME}server"

[ -d "$SCRIPT_PATH/games/$GAME" ] || fail "This game is not supported!"

echo "Installing $GAME to $GAMEDIR as user $GAMEUSER ..."

# Install common dependencies
export DEBIAN_FRONTEND=noninteractive
install_common_dependencies

# Download LinuxGSM and game server files
LGSM_PATH="$GAMEDIR/linuxgsm.sh"
runuser -l "$GAMEUSER" -c "wget -O \"$LGSM_PATH\" https://linuxgsm.sh"
runuser -l "$GAMEUSER" -c "chmod +x \"$LGSM_PATH\""
runuser -l "$GAMEUSER" -c "cd \"$GAMEDIR\"; bash linuxgsm.sh \"$GAMESERVER\""

# Install game dependencies
bash "$GAMEDIR/$GAMESERVER" auto-install

# Install game server
runuser -l "$GAMEUSER" -c "cd \"$GAMEDIR\"; ./\"$GAMESERVER\" auto-install"

# Apply default config, if needed
run_game_script "initial_config.sh"
