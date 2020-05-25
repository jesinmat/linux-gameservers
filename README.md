# Linux Gameservers
Automatic installation of game servers using LinuxGSM.

## Usage

After cloning this repository, you can list all supported games with
```console
auto_install.sh --list
```

To install a game server, run
```bash
sudo auto_install.sh --game GAME --user USERNAME [--path /path/to/server/directory]
```

- GAME - short name of the game you want to install. You can see all supported games in the *games/* directory.
- USERNAME - username of the owner of game files. This can be you or any other user. Root can NOT own a game server for security reasons.
- PATH - Destination for server files. Directory will be created if it doesn't exist and assigned to *USERNAME*. Default: `/home/USERNAME/gameserver`

#### Example:
```console
john@ubuntu:~/linux-gameservers$ sudo auto_install.sh --game cs --user john --path /home/john/games/
```