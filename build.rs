/*
This script will execute before compiling the main package
*/

use std::env;

const ROS_DISTRO: &str = "ROS_DISTRO";
// function to check if ros is sourced or not
fn check_rosenvironment(env_var: &'static str) -> String {
    if let Ok(value) = env::var(env_var) {
        value
    } else {
        panic!(
            "{} environment variable not set - please source ROS 2 installation first.",
            env_var
        );
    }
}

fn main(){
    let ros_distro = check_rosenvironment(ROS_DISTRO);
    println!("ros_distro=\"{ros_distro}\"");
}