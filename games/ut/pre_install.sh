#!/bin/bash

for i in lib32gcc-s1 lib32gcc1 lib32stdc++6 xz-utils; do
  apt install -y "$i"
done