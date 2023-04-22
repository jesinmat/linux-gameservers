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

function list_games {
    printf "| %-10s | %-50s |\n" "Code" "Name"
    printf "%s\n" "-------------------------------------------------------------------"
    for DIR in games/*; do
        if [ -d "$DIR" ]; then
            . "$DIR/game_properties.sh"
            printf "| %-10s | %-50s |\n" "$GAME" "$GAME_LONG_NAME"
        fi
    done
    printf "%s\n" "-------------------------------------------------------------------"
}

function install_common_dependencies {
    # Add support for 32bit apps
    dpkg --add-architecture i386
    apt update
    apt install -y mailutils postfix curl wget file tar bzip2 gzip unzip bsdmainutils python3 util-linux ca-certificates binutils bc jq tmux iproute2 netcat xz-utils
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

function run_as_user {
    runuser -l "$GAMEUSER" -c "$1"
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
        -l|--list)
            list_games
            exit 0
        ;;
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
run_as_user "wget -O \"$LGSM_PATH\" https://linuxgsm.sh"
run_as_user "chmod +x \"$LGSM_PATH\""
run_as_user "cd \"$GAMEDIR\"; bash linuxgsm.sh \"$GAMESERVER\""

# Run pre-install script
run_game_script "pre_install.sh"

# Install game dependencies
# If this script it running in docker, we need to mask it for this command
if [ -f /.dockerenv ]; then
    mv /.dockerenv /.dockerenv.tmp
fi

bash "$GAMEDIR/$GAMESERVER" auto-install

if [ -f /.dockerenv.tmp ]; then
    mv /.dockerenv.tmp /.dockerenv
fi

# Install game server
run_as_user "cd \"$GAMEDIR\"; ./\"$GAMESERVER\" auto-install"

# Run post-install script
run_game_script "post_install.sh"

exit 0
