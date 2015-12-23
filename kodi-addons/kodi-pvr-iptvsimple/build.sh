#!/bin/bash

: ${SRC_URL:='https://github.com/AndreyPavlenko/pvr.iptvsimple.git'}
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='0'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:src/client.h | awk '/#define PVR_CLIENT_VERSION/ {print $3}' | tr -d '"')
    echo "$(_pkg_version ${version} $delta)"
}

_deb_dir() {
    cp -r "$1/debian" "$BUILD_DIR"
    cp -r "$DIR/debian" "$BUILD_DIR"
    echo "$BUILD_DIR/debian"
}

_main $@
