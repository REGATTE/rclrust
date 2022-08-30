/*
This script will execute before compiling the main package
*/

use std::env;
use std::path::PathBuf;

const ROS_DISTRO: &str = "ROS_DISTRO";
// function to check if ros is sourced or not


fn main(){
    let ros_distro = rclrust_common::check_rosenvironment(ROS_DISTRO);
    println!("ros_distro=\"{ros_distro}\"");

    rclrust_common::rust_version();

    
}