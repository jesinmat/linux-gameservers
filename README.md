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
| 7 Days to Die | sdtd | - |
| ARK: Survival Evolved | ark | - | 7777, 7778, 27015, 27020
| ARMA 3 | arma3 | - | 2302, 2303, 2304, 2305
| Action Half-Life | ahl | - | 27015
| Action: Source | ahl2 | - | 27015, 27020
| Assetto Corsa | ac | - |
| Avorion | av | - | 27000
| Ballistic Overkill | bo | - |
| Barotrauma | bt | - |
| Base Defense | bd | - | 27015
| Battalion 1944 | bt1944 | - | 7777, 7778, 7779, 7780
| Battlefield 1942 | bf1942 | - |
| Battlefield: Vietnam | bfv | - |
| Black Mesa: Deathmatch | bmdm | - | 27015, 27020
| Blade Symphony | bs | - | 27015, 27020
| BrainBread 2 | bb2 | - | 27015, 27020
| BrainBread | bb | - | 27015
| Call of Duty 2 | cod2 | - | 28960
| Call of Duty 4 | cod4 | - | 28960
| Call of Duty | cod | - | 28960
| Call of Duty: United Offensive | coduo | - | 28960
| Call of Duty: World at War | codwaw | - | 28960
| Chivalry: Medieval Warfare | cmw | - | 7777, 7779, 27960
| Codename CURE | cc | - | 27015, 27020
| Colony Survival | col | - | 27004, 27005
| Counter-Strike 1.6 | cs | - | 27015
| Counter-Strike: Condition Zero | cscz | - | 27015
| Counter-Strike: Global Offensive | csgo | - | 27015, 27020
| Counter-Strike: Source | css | - | 27015, 27020
| Day of Defeat | dod | - | 27015
| Day of Defeat: Source | dods | - | 27015, 27020
| Day of Infamy | doi | - | 27015, 27020
| Deathmatch Classic | dmc | - | 27015
| Don't Starve Together | dst | - |
| Double Action: Boogaloo | dab | - | 27015, 27020
| Dystopia | dys | - | 27015, 27020
| ET: Legacy | etl | - |
| Eco | eco | GAME_SERVER_NAME<br>GAME_SERVER_PASS<br>GAME_SERVER_PUBLIC<br>GAME_SERVER_UPNP | 3000, 3001
| Empires Mod | em | - | 27015, 27020
| Factorio | fctr | - | 34197, 34198
| Fistful of Frags | fof | - | 27015, 27020
| GTA San Andreas Multiplayer | samp | GAME_RCON_PASS<br>GAME_SERVER_NAME | 7777 
| Garrys Mod | gmod | - | 27015, 27020
| Half-Life 2: Deathmatch | hl2dm | - | 27015, 27020
| Half-Life Deathmatch: Source | hldms | - | 27015, 27020
| Half-Life: Deathmatch | hldm | - | 27015
| Hurtworld | hw | - | 12871, 12881
| IOSoccer | ios | - | 27015, 27020
| Insurgency | ins | - | 27015, 27020
| Insurgency: Sandstorm | inss | - | 27102, 27131
| Jedi Knight II: Jedi Outcast | jk2 | - | 27960
| Just Cause 2 | jc2 | - |
| Just Cause 3 | jc3 | - |
| Killing Floor 2 | kf2 | - | 20560
| Killing Floor | kf | - |
| Left 4 Dead 2 | l4d2 | - | 27015
| Left 4 Dead | l4d | - | 27015
| MORDHAU | mh | - | 7777, 15000, 27015
| Medal of Honor: Allied Assault | mohaa | - | 12203
| Memories of Mars | mom | - | 7777, 15000
| Minecraft Bedrock Edition | mcb | - | 19132 
| Minecraft Java Edition | mc | GAME_ADMIN<br>GAME_SERVER_NAME | 25565 
| Multi Theft Auto | mta | - |
| Mumble | mumble | - | 64738, 64738
| NS2: Combat | ns2c | - | 27015, 27016, 8080
| Natural Selection 2 | ns2 | - | 27015, 27016, 8080
| Natural Selection | ns | - | 27015
| No More Room in Hell | nmrih | - | 27015, 27020
| Nuclear Dawn | nd | - | 27015, 27020
| Onset | onset | - |
| Opposing Force | opfor | - | 27015
| PaperMC | pmc | - | 25565, 25565, 25575
| Pavlov VR | pvr | - | 7777, 8177
| Pirates Vikings & Knights II | pvkii | - | 27015, 27020
| Post Scriptum: The Bloody Seventh | pstbs | - | 10027, 10037
| Project Cars | pc | - |
| Project Zomboid | pz | - |
| Quake 2 | q2 | - | 27910
| Quake III Arena | q3 | - | 27960
| Quake Live | ql | - |
| Quake World | qw | - |
| Red Orchestra: Ostfront 41-45 | ro | - |
| Return to Castle Wolfenstein | rtcw | - | 27960
| Ricochet | ricochet | - | 27015
| Rising World | rw | - |
| Rust | rust | - | 28015, 28016, 28082
| SCP: Secret Laboratory ServerMod | scpslsm | - | 7777
| SCP: Secret Laboratory | scpsl | - | 7777
| San Andreas Multiplayer | samp | - | 7777
| Soldat | sol | - |
| Soldier Of Fortune 2: Gold Edition | sof2 | - | 20100
| SourceForts Classic | sfc | - | 27015, 27020
| Squad | squad | - | 7787, 27165
| Starbound | sb | GAME_SERVER_NAME<br>GAME_SERVER_PUBLIC<br>GAME_RCON_PASS<br>GAME_STEAM_USER<br>GAME_STEAM_PASS |  21025-21026
| Stationeers | st | - | 27500, 27015
| StickyBots | sbots | - | 7777, 27015
| Sven Co-op | sven | - | 27015
| Team Fortress 2 | tf2 | - | 27015, 27020
| Team Fortress Classic | tfc | - | 27015
| Teamspeak 3 | ts3 | - | 9987, 10011, 30033
| Teeworlds | tw | - | 8303
| Terraria | terraria | - |
| The Specialists | ts | - | 27015
| Tower Unite | tu | - | 7777, 7778, 27015
| Unreal Tournament 2004 | ut2k4 | - |
| Unreal Tournament 3 | ut3 | - | 7777, 6500
| Unreal Tournament 99 | ut99 | - |
| Unreal Tournament | ut | - | 7777-7788, 27900
| Unturned | unt | - | 27015, 27016
| Valheim | vh | GAME_SERVER_NAME<br>GAME_SERVER_PASS<br>GAME_SERVER_PUBLIC | 2456-2457
| Vampire Slayer | vs | - | 27015
| Vintage Story | vints | - |
| Warfork | wf | - | 44400, 44444
| WaterfallMC | wmc | - |
| Wolfenstein: Enemy Territory | wet | - |
| Wurm Unlimited | wurm | - |
| Zombie Master: Reborn | zmr | - | 27015, 27020
| Zombie Panic! Source | zps | - | 27015, 27020

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
