RFLAGS="-C link-arg=-s"

build: build-ft

build-ft: contracts/regular-ft
	rustup target add wasm32-unknown-unknown
	RUSTFLAGS=$(RFLAGS) cargo build -p regular-ft --target wasm32-unknown-unknown --release
	mkdir -p res
	cp target/wasm32-unknown-unknown/release/regular_ft.wasm ./res/regular_ft.wasm

release:
	$(call docker_build,_rust_setup.sh)
	mkdir -p res
	cp target/wasm32-unknown-unknown/release/regular_ft.wasm res/regular_ft_release.wasm

test: build
	RUSTFLAGS=$(RFLAGS) cargo test --lib -- --nocapture

clean:
	cargo clean
	rm -rf res/

define docker_build
	docker build -t my-regular-builder .
	docker run \
		--mount type=bind,source=${PWD},target=/host \
		--cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
		-w /host \
		-e RUSTFLAGS=$(RFLAGS) \
		-i -t my-regular-builder \
		/bin/bash $(1)
endef