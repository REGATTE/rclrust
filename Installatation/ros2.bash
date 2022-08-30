#!/bin/bash
cd

sudo apt update && sudo apt upgrade

# Installs curl if not already installed
sudo apt install curl

# Install pip if not already installed
sudo apt-get install python3-pip

# Install ntfy, a desktop notification service to notify updates and error messages
sudo pip3 install ntfy

sudo pip3 install opencv-python
sudo pip3 install opencv-contrib-python

DISPLAY=:0.0 notify-send "Installing ROS2...."
DISPLAY=:0.0 notify-send "Checking Ubuntu Version"


if [[ $(lsb_release -sc) == "focal" ]]; then
    DISPLAY=:0.0 notify-send "Installing ROS2 FOXY"

    echo "Locale Check"
    locale  # check for UTF-8
    sudo apt update && sudo apt install locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
    locale  # verify settings

    # Setup Sources
    echo "setting up Sources"
    sudo apt-get update 
    sudo apt-get install -y software-properties-common 
    sudo add-apt-repository universe 
    sudo apt-get install -y curl gnupg2 lsb-release build-essential

    sudo apt update && sudo apt install curl gnupg2 lsb-release
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

    # install ROS2 Packages
    echo "installing ros2 packages"
    sudo apt update
    sudo apt install ros-foxy-desktop

    # source repo's
    grep -F "source /opt/ros/foxy/setup.bash" ~/.bashrc ||
    echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
    source ~/.bashrc
    sudo apt install python3-colcon-common-extensions
    sudo apt install ros-foxy-eigen3-cmake-module
    sudo pip3 install -U empy pyros-genmsg setuptools
    sudo apt install ros-foxy-gazebo-ros-pkgs

    sudo pip install -U rosdep
    sudo rosdep init
    rosdep update

    echo "Done installing ROS2 - FOXY"

    mkdir -p ros2_ws/src 
    cd ros2_ws
    colcon build
    cd

    grep -F "source ~/ros2_ws/install/setup.sh" ~/.bashrc ||
    echo "source ~/ros2_ws/install/setup.sh" >> ~/.bashrc
    source ~/.bashrc

    set +u

elif [[ $(lsb_release -sc) == "jammy" ]]; then
    DISPLAY=:0.0 notify-send 'Installing ROS2 Humble'
    echo "Locale Check"
    locale  # check for UTF-8

    sudo apt update && sudo apt install locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8

    locale  # verify settings

    # enbaling Universe Repository
    sudo apt install software-properties-common
    sudo add-apt-repository universe
    sudo apt-get install -y curl gnupg2 lsb-release build-essential

    # Setup Sources
    echo "setting up Sources"
    sudo apt update && sudo apt install curl gnupg lsb-release
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

    # install ROS2 Packages
    echo "installing ros2 packages"
    sudo apt update
    sudo apt upgrade
    sudo apt install ros-humble-desktop

    # source repo's
    grep -F "source /opt/ros/humble/setup.bash" ~/.bashrc ||
    echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
    source ~/.bashrc
    sudo apt install python3-colcon-common-extensions
    sudo apt install ros-humble-eigen3-cmake-module
    sudo pip3 install -U empy pyros-genmsg setuptools
    sudo apt install ros-humble-gazebo-ros-pkgs

    sudo pip install -U rosdep
    sudo rosdep init
    rosdep update

    echo "Done installing ROS2 - HUMBLE"

    mkdir -p ros2_ws/src 
    cd ros2_ws
    colcon build
    cd

    grep -F "source ~/ros2_ws/install/setup.sh" ~/.bashrc
    echo "source ~/ros2_ws/install/setup.sh" >> ~/.bashrc
    source ~/.bashrc

    set +u 
else
    DISPLAY=:0.0 notify-send "Ubuntu Version not compatible."
    echo "ubuntu version not compantibel"
fi
