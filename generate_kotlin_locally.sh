#!/bin/bash

cd "$(dirname $0)"
set -eo pipefail

rm -rf crates/kotlin-ffi/android/src/main/kotlin/com/reown/yttrium/

cargo ndk -t aarch64-linux-android build --profile=uniffi-release-kotlin --features=uniffi/cli
cargo run --features=uniffi/cli --bin uniffi-bindgen generate --library target/aarch64-linux-android/uniffi-release-kotlin/libuniffi_yttrium.so --language kotlin --out-dir yttrium/kotlin-bindings

mkdir -p crates/kotlin-ffi/android/src/main/kotlin/com/reown/yttrium

mv yttrium/kotlin-bindings/uniffi/uniffi_yttrium/uniffi_yttrium.kt crates/kotlin-ffi/android/src/main/kotlin/com/reown/yttrium/
mv yttrium/kotlin-bindings/uniffi/yttrium/yttrium.kt crates/kotlin-ffi/android/src/main/kotlin/com/reown/yttrium/

./gradlew clean assembleRelease

cp crates/kotlin-ffi/android/build/outputs/aar/*.aar ..