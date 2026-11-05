#!/bin/bash
# From values in gradle/tools.versions.toml
export CMDLINE_TOOLS_VERSION=13114758
export CMDLINE_TOOLS_CHECKSUM="7ec965280a073311c339e571cd5de778b9975026cfcbe79f2b1cdcb1e15317ee"
export BUILD_TOOLS_VERSION=35.0.0
export CMAKE_VERSION=4.0.2
export JDK_VERSION=17
export NDK_VERSION=26.1.10909125
export RUSTUP_VERSION=1.24.3
export RUST_TOOLCHAIN_VERSION=1.83.0

# For some reason SDK 37 can't be installed
export PROJECT_COMPILE_SDK=36

# Based on Dockerfile utils/repr_build/Dockerfile
export JAVA_HOME=/usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain ${RUST_TOOLCHAIN_VERSION} --profile minimal
export PATH="$HOME/.cargo/bin:$PATH"

export CMDLINE_TOOLS_ZIP="commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip"
export ANDROID_HOME="$HOME/Android/Sdk"
mkdir -p ${ANDROID_HOME}/cmdline-tools \
	&& cd ${ANDROID_HOME}/cmdline-tools \
	&& wget https://dl.google.com/android/repository/${CMDLINE_TOOLS_ZIP} \
	&& echo "${CMDLINE_TOOLS_CHECKSUM} ${CMDLINE_TOOLS_ZIP}" | sha256sum -c - \
	&& unzip ${CMDLINE_TOOLS_ZIP} \
	&& rm ${CMDLINE_TOOLS_ZIP} \
	&& mv cmdline-tools latest
export PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:$PATH"

yes | sdkmanager --install \
	"platform-tools" \
	"platforms;android-${PROJECT_COMPILE_SDK}" \
	"build-tools;${BUILD_TOOLS_VERSION}" \
	"cmake;${CMAKE_VERSION}" \
	"ndk;${NDK_VERSION}"
export ANDROID_NDK_HOME="${ANDROID_HOME}/ndk/${NDK_VERSION}"
export PATH="${ANDROID_HOME}/platform-tools:$PATH"
