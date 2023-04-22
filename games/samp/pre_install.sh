#!/bin/bash

for i in lib32gcc1 lib32gcc-s1 lib32stdc++6 libstdc++6; do
  apt install -y "$i"
done