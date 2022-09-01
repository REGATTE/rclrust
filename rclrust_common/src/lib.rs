use itertools::Itertools;
use std::collections::HashMap;
use std::env;
use std::fmt::format;
use std::fs::{self, File};
use std::io::Read;
use std::path::Path;

extern crate version_check as rustc;

/*
Function to check if ros has been sourced in the environment or not.
*/
pub fn check_rosenvironment(env_var: &'static str) -> String {
    if let Ok(value) = env::var(env_var) {
        value
    } else {
        panic!(
            "{} environment variable not set - please source ROS 2 installation first as follows",
            env_var
        );
    }
}

/*
Rus function to check rust version.
If minimum version not met, then raise an error.
*/
pub fn rust_version() {
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

// create rust FFI bindings - Configure and generate Rust bindings for a C/C++ header.
pub fn bindgenBuilder() -> bindgen::Builder {
    // Configuration to generate bindings
    let mut builder = bindgen::Builder::default()
        .derive_copy(false)
        .size_t_is_usize(false)
        .default_enum_style(bindgen::EnumVariation::Rust {
            non_exhaustive: false,
        });
    if let Ok(cmake_includes) = env::var("CMAKE_INCLUDE_DIRS") {
        // we are running from cmake, do special thing.
        let mut includes = cmake_includes.split(":").collect::<Vec<_>>();
        includes.sort_unstable();
        includes.dedup();

        for x in &includes {
            let clang_arg = format!("-I{}", x);
            println!("adding clang arg: {}", clang_arg);
            builder = builder.clang_arg(clang_arg);
        }

        env::var("CMAKE_LIBRARIES")
            .unwrap_or_default()
            .split(":")
            .into_iter()
            .filter(|s| s.contains(".so") || s.contains(".dylib"))
            .flat_map(|l| Path::new(l).parent().and_then(|p| p.to_str()))
            .unique()
            .for_each(|pp| println!("cargo:rustc-link-search=native={}", pp));
    } else {
        let ament_prefix_var_name = "AMENT_PREFIX_PATH";
        let ament_prefix_var = env::var(ament_prefix_var_name).expect("Source ROS!!");
        for p in ament_prefix_var.split(':') {
            let path = Path::new(p).join("include");
            let entries = std::fs::read_dir(path.clone());
            if let Ok(e) = entries {
                let dirs = e
                    .filter_map(|a| {
                        let path = a.unwrap().path();
                        if path.is_dir() {
                            Some(path)
                        } else {
                            None
                        }
                    })
                    .collect::<Vec<_>>();
                builder = dirs.iter().fold(builder, |builder, d| {
                    if let Some(leaf) = d.file_name() {
                        let double_include_path = Path::new(d).join(leaf);
                        if double_include_path.is_dir() {
                            let temp = d.to_str().unwrap();
                            builder.clang_arg(format!("-I{}", temp))
                        } else {
                            // pre humble case, where we did not have include/package/package
                            let temp = d.parent().unwrap().to_str().unwrap();
                            builder.clang_arg(format!("-I{}", temp))
                        }
                    } else {
                        builder
                    }
                });
            }
            let lib_path = Path::new(p).join("lib");
            lib_path.to_str().map(|s| {
                println!("cargo:rustc-link-search=native={}", s);
            });
        }
    }

    return builder;
}
