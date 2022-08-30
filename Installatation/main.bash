#!/bin/bash

sudo apt-get update

# installs, if not already installed
sudo apt-get install git
sudo apt-get install curl
sudo apt-get install python3-pip

# Install rust
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh


if [[ $(uname -m) == "aarch64" ]]; then
    sudo apt-get install rpi.gpio
fi
chmod a+x Installatation/ros2.bash
sudo sh Installatation/ros2.bash
