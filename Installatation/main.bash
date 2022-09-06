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

git clone https://gist.github.com/7101c20b7055d68e6f57b34687e4b8cd.git

mv 7101c20b7055d68e6f57b34687e4b8cd ros2_install

chmod a+x ros2_install/ROS2_FOXY_HUMBLE_INSTALL.bash
bash ros2_install/ROS2_FOXY_HUMBLE_INSTALL.bash
