#!/bin/bash

function fail {
    printf '%s\n' "$1" >&2
    exit 1
}

function usage_format {
    printf "    %s\n        %s\n" "$1" "$2"
}

function usage {
    echo "Usage: $0 -g game_code -u username [ -p install_path ] [ --steam-accept-eula ]"
    echo "Example: $0 -g mc -u john -p /home/john/gameserver"
    usage_format "-g, --game" "Select game to install. Argument must be one of the games located in ./games/ directory."
    usage_format "-u, --username" "Install game as selected user. User will be granted ownership of all game files. Root user not allowed."
    usage_format "-p, --install_path" "Installation path for server. Directory will be created if it doesn't exist. Default: /home/(username)/"
    usage_format "--steam-accept-eula" "Automatically accept Steam EULA for servers that require Steam."
}

function install_common_dependencies {
    apt update
    apt install -y mailutils postfix curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux
}

function yes_or_exit {
    read -p "$1" CHOICE
    case "$CHOICE" in
        y|Y ) break;;
        n|N ) fail "Installation cannot continue.";;
        * ) fail "Invalid choice.";;
    esac
}

function validate_user {
    if ! getent passwd "$GAMEUSER" > /dev/null 2>&1; then
        fail "This user does not exist."
    elif [ $(id -u "$GAMEUSER") -eq 0 ]; then
        fail "Root user cannot run game servers. Please select another user."
    fi
}

function install_game_dependencies {
    local SCRIPT="$SCRIPT_PATH/games/$GAME/install_dependencies.sh"
    if [ grep -qi "steamcmd" "$SCRIPT" -eq 0 ] && [ "$STEAM_ACCEPT_LICENSE" -ne "true" ]; then
        echo "This server requires Steam. You must accept Steam EULA to proceed."
        yes_or_exit "Do you accept Steam EULA? (y/n):"
    fi
    run_game_script "install_dependencies.sh"
}

function run_game_script {
    local SCRIPT="$SCRIPT_PATH/games/$GAME/$1"
    if [ -f "$SCRIPT" ] ; then
        chmod +x "$SCRIPT"
        bash "$SCRIPT"
    fi
}

if [ "$#" -lt 1 ]; then
    usage
    exit 1
fi

SCRIPT_PATH=$(dirname $(realpath "$0"))
GAME=
GAMEUSER=
STEAM_ACCEPT_LICENSE="false"

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
        --steam-accept-eula)
            STEAM_ACCEPT_LICENSE="true"
            shift # past argument
        ;;
        *)    # unknown option
            fail "Illegal argument: $1. Run script without arguments to see usage."
        ;;
    esac
done

[ -z "$GAME" ] && fail "No game selected!"
[ -z "$GAMEUSER" ] && fail "No user selected!"
[ -z "$GAMEDIR" ] && GAMEDIR="/home/$GAMEUSER"

validate_user

if [ ! -d "$GAMEDIR" ]; then
    mkdir -p "$GAMEDIR"
    chown $GAMEUSER: "$GAMEDIR"
fi

GAMESERVER="${GAME}server"

[ -d "$SCRIPT_PATH/games/$GAME" ] || fail "This game is not supported!"

echo "Installing $GAME to $GAMEDIR as user $GAMEUSER ..."

export GAMEUSER
export GAMESERVER

# Install common dependencies
install_common_dependencies

# Install game dependencies
install_game_dependencies

# Download LinuxGSM and game server files
LGSM_PATH="$GAMEDIR/linuxgsm.sh"
runuser -l "$GAMEUSER" -c "wget -O \"$LGSM_PATH\" https://linuxgsm.sh"
runuser -l "$GAMEUSER" -c "chmod +x \"$LGSM_PATH\""
runuser -l "$GAMEUSER" -c "cd \"$GAMEDIR\"; bash linuxgsm.sh \"$GAMESERVER\""

# Install game server
runuser -l "$GAMEUSER" -c "cd \"$GAMEDIR\"; ./\"$GAMESERVER\" auto-install"

# Apply default config, if needed
run_game_script "initial_config.sh"
