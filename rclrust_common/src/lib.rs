use std::env;

extern crate version_check as rustc;

/*
Function to check if ros has been sourced in the environment or not.
*/
pub fn check_rosenvironment(env_var: &'static str) -> String {
    if let Ok(value) = env::var(env_var) {
        value
    } else {
        panic!(
            "{} environment variable not set - please source ROS 2 installation first as follows: 

            echo "source ~/ros2_ws/install/setup.sh" >> ~/.bashrc

            source ~/.bashrc
            
            and restart terminal.",

            env_var
        );
    }
}

/*
Rus function to check rust version.
If minimum version not met, then raise an error.
*/
pub fn rust_version(){
    if rustc::is_min_version("1.63.0").unwrap_or(false) {
        println!("cargo:rustc-cfg=question_mark_operator");
    }
}


pub fn print_cargo_watches() {
    println!("cargo:rerun-if-env-changed=AMENT_PREFIX_PATH");
    println!("cargo:rerun-if-env-changed=CMAKE_INCLUDE_DIRS");
    println!("cargo:rerun-if-env-changed=CMAKE_LIBRARIES");
    println!("cargo:rerun-if-env-changed=CMAKE_IDL_PACKAGES");
    println!("cargo:rerun-if-env-changed=IDL_PACKAGE_FILTER");
}
