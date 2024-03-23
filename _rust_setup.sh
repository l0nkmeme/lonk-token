#/bin/bash
VER=1.61.0
rustup toolchain install $VER
rustup default $VER
rustup target add wasm32-unknown-unknown
cargo build -p regular-ft --target wasm32-unknown-unknown --release