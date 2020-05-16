#!/bin/bash
# Enable non-free repository for steamcmd
sed -i 's/^#\(.* non-free\)/\1/' /etc/apt/sources.list.d/sources.list

apt update
apt install -y lib32gcc1 libstdc++6 lib32stdc++6 steamcmd
