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
| Assetto Corsa | ac | - |
| Action Half-Life | ahl | - |
| Action: Source | ahl2 | - |
| ARK: Survival Evolved | ark | - |
| ARMA 3 | arma3 | - |
| Avorion | av | - |
| BrainBread | bb | - |
| BrainBread 2 | bb2 | - |
| Base Defense | bd | - |
| Battlefield 1942 | bf1942 | - |
| Battlefield: Vietnam | bfv | - |
| Black Mesa: Deathmatch | bmdm | - |
| Ballistic Overkill | bo | - |
| Blade Symphony | bs | - |
| Barotrauma | bt | - |
| Battalion 1944 | bt1944 | - |
| Codename CURE | cc | - |
| Chivalry: Medieval Warfare | cmw | - |
| Call of Duty | cod | - |
| Call of Duty 2 | cod2 | - |
| Call of Duty 4 | cod4 | - |
| Call of Duty: United Offensive | coduo | - |
| Call of Duty: World at War | codwaw | - |
| Colony Survival | col | - |
| Counter Strike 1.6 | cs | - | 27015 
| Counter-Strike: Condition Zero | cscz | - |
| Counter-Strike: Global Offensive | csgo | - |
| Counter-Strike: Source | css | - |
| Double Action: Boogaloo | dab | - |
| Deathmatch Classic | dmc | - |
| Day of Defeat | dod | - |
| Day of Defeat: Source | dods | - |
| Day of Infamy | doi | - |
| Don't Starve Together | dst | - |
| Dystopia | dys | - |
| Eco | eco | - | 3000, 3001
| Empires Mod | em | - |
| ET: Legacy | etl | - |
| Factorio | fctr | - |
| Fistful of Frags | fof | - |
| Garrys Mod | gmod | - |
| GTA San Andreas Multiplayer | samp | GAME_RCON_PASS<br>GAME_SERVER_NAME | 7777 
| Half-Life 2: Deathmatch | hl2dm | - |
| Half-Life: Deathmatch | hldm | - |
| Half-Life Deathmatch: Source | hldms | - |
| Hurtworld | hw | - |
| Insurgency | ins | - |
| Insurgency: Sandstorm | inss | - |
| IOSoccer | ios | - |
| Just Cause 2 | jc2 | - |
| Just Cause 3 | jc3 | - |
| Jedi Knight II: Jedi Outcast | jk2 | - |
| Killing Floor | kf | - |
| Killing Floor 2 | kf2 | - |
| Left 4 Dead | l4d | - |
| Left 4 Dead 2 | l4d2 | - |
| Minecraft Java Edition | mc | GAME_ADMIN<br>GAME_SERVER_NAME | 25565 
| Minecraft Bedrock Edition | mcb | - | 19132 
| MORDHAU | mh | - |
| Medal of Honor: Allied Assault | mohaa | - |
| Memories of Mars | mom | - |
| Multi Theft Auto | mta | - |
| Mumble | mumble | - |
| Nuclear Dawn | nd | - |
| No More Room in Hell | nmrih | - |
| Natural Selection | ns | - |
| Natural Selection 2 | ns2 | - |
| NS2: Combat | ns2c | - |
| Onset | onset | - |
| Opposing Force | opfor | - |
| Project Cars | pc | - |
| PaperMC | pmc | - |
| Post Scriptum: The Bloody Seventh | pstbs | - |
| Pirates Vikings & Knights II | pvkii | - |
| Pavlov VR | pvr | - |
| Project Zomboid | pz | - |
| Quake 2 | q2 | - |
| Quake III Arena | q3 | - | 27960
| Quake Live | ql | - |
| Quake World | qw | - |
| Ricochet | ricochet | - |
| Red Orchestra: Ostfront 41-45 | ro | - |
| Return to Castle Wolfenstein | rtcw | - |
| Rust | rust | - |
| Rising World | rw | - |
| Satisfactory | sf | - |
| Starbound | sb | - |
| StickyBots | sbots | - |
| SCP: Secret Laboratory | scpsl | - |
| SCP: Secret Laboratory ServerMod | scpslsm | - |
| 7 Days to Die | sdtd | - |
| SourceForts Classic | sfc | - |
| Soldier Of Fortune 2: Gold Edition | sof2 | - |
| Soldat | sol | - |
| Squad | squad | - |
| Stationeers | st | - |
| Sven Co-op | sven | - |
| Terraria | terraria | - |
| Team Fortress 2 | tf2 | - |
| Team Fortress Classic | tfc | - |
| The Specialists | ts | - |
| Teamspeak 3 | ts3 | - |
| Tower Unite | tu | - |
| Teeworlds | tw | - |
| Unturned | unt | - |
| Unreal Tournament | ut | - | 7777-7788, 27900
| Unreal Tournament 2004 | ut2k4 | - |
| Unreal Tournament 3 | ut3 | - |
| Unreal Tournament 99 | ut99 | - |
| Valheim | vh | - |
| Vampire Slayer | vs | - |
| Vintage Story | vints | - |
| Wolfenstein: Enemy Territory | wet | - |
| Warfork | wf | - |
| WaterfallMC | wmc | - |
| Wurm Unlimited | wurm | - |
| Zombie Master: Reborn | zmr | - |
| Zombie Panic! Source | zps | - |

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
