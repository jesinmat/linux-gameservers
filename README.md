# Linux Gameservers
Tool for automatic installation of game servers. Wrapper for [LinuxGSM](https://linuxgsm.com/).

* [Requirements](#requirements)
* [Usage](#usage)
* [Environment variables](#environment-variables)
* [Supported games](#supported-games)
* [Contributing](#contributing)
    * [Fixing missing dependencies](#fixing-missing-dependencies)
    * [Changing server settings](#changing-server-settings)

## Requirements

The following packages must be preinstalled:
- apt
- sudo

This tool was written for Debian-based distributions, but might work on other platforms.

## Usage

After cloning this repository, you can list all supported games with
```console
auto_install.sh --list
```

To install a game server interactively, run
```console
sudo auto_install.sh --game GAME --user USERNAME [--path PATH]
```

- GAME - short name of the game you want to install. You can see all supported games by running the script with the `--list` option.
- USERNAME - username of the owner of game files. This can be you or any other user. Root can NOT own a game server for security reasons.
- PATH - Directory for server files. Directory will be created if it doesn't exist and assigned to *USERNAME*. Default: `/home/$USERNAME/gameserver`

#### Example
```console
john@ubuntu:~/linux-gameservers$ sudo auto_install.sh --game cs --user john --path /home/john/games/
```

You will be prompted to enter required data for setting up the server. If you want to avoid this, you can set all required data beforehand through [environment variables](#environment-variables).

## Environment variables

To skip interactive data input during game server installation, you can use preset environment variables to provide all required info.

```console
john@ubuntu:~$ export GAME_SERVER_NAME="My own game server"
john@ubuntu:~$ export GAME_ENABLE_PVP="false"
john@ubuntu:~$ ... # install the game using auto_install.sh
```

You can see all supported variables for each game in the [Supported games](#supported-games) list.

## Supported games

| Game | Code | Supported variables | Default port |
| ---- | ---- | --------- | ------------ |
| Counter Strike 1.6 | cs | - | 27015 |
| GTA San Andreas Multiplayer | samp | GAME_RCON_PASS<br>GAME_SERVER_NAME | 7777 |
| Minecraft | mc | GAME_ADMIN<br>GAME_SERVER_NAME | 25565 |
| Quake III Arena | q3 | - | 27960


## Contributing

Contributions are welcome. Adding a game is simple:
1. Go to [LinuxGSM supported games](https://linuxgsm.com/servers/) and open the Install page of your selected game server. 
2. Clone this repository into a clean Debian-based system (VM is recommended).
3. Create a new folder in `/games/`. Its name must be the short game name found on LinuxGSM Install page (for example `mc` for Minecraft).
4. Create a new file in the folder named `game_properties.sh` with the following contents:
    ```shell
    GAME="mc" # Replace with short name of your game
    GAME_LONG_NAME="Minecraft (Java Edition)" # Replace with full name of your game
    ```
5. *[Recommended]* Create a snapshot of your VM.
6. Install the game using `auto_install.sh`. Installer should fix all missing dependencies.
7. Launch the game server. If the server doesn't start due to a missing package, see [how to fix a missing dependency](#fixing-missing-dependencies).
8. *[Optional]* [Add user configuration](#changing-server-settings) for the server.
9. Update this `README.md` file with the new game.


### Fixing missing dependencies

In case the auto installer doesn't install all required dependencies, find the missing packages and create a `pre_install.sh` script in the game directory.
```shell
#!/bin/bash
# Example pre_install.sh script
apt install -y lib32gcc1 python netcat
```
If you created a snapshot of your VM, restore it and try installing the server again with your new script.

### Changing server settings
If a game server requires post-install configuration, you can do it using a `post_install.sh` script. You can also use it to load configuration from environment variables. When asking the user for input, make sure you also **support environment variables** and default values for non-interactive installation.

Several variables are available in `post_install.sh` script, such as:
- $GAME - short game name
- $GAME_LONG_NAME - full game name
- $GAMEDIR - absolute path to the server directory
- $GAMEUSER - username of the game files owner

Do not modify or create server files directly as this would assign them to the root account. Instead, use provided `run_as_user` function.
```shell
 run_as_user 'echo John >> '"$GAMEDIR"'/serverfiles/admins.txt' 
```
#### Example
Check if environment variable GAME_ADMIN is set. If not, prompt user for input. If user input can't be read, set empty admin.

```shell
#!/bin/bash
# Example post_install.sh script

# Set server admin username
if [ -z "$GAME_ADMIN" ]; then
    read -p "Server admin username: " GAME_ADMIN || GAME_ADMIN=''
    echo
fi
run_as_user 'echo '"$GAME_ADMIN"' > '"$GAMEDIR"'/serverfiles/admins.txt'
```