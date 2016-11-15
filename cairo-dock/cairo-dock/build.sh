#!/bin/bash

SRC_URL='https://github.com/Cairo-Dock/cairo-dock-core.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='0'
    local version="$(git --git-dir="$SRC_DIR/.git" show $REV:CMakeLists.txt | grep -Po '(?<=set \(VERSION ").+(?="\))')"
    _pkg_version "$version" "$delta"
}

_main $@
