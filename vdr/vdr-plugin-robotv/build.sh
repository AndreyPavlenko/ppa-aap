#!/bin/bash

SRC_URL='https://github.com/pipelka/vdr-plugin-robotv.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='0'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:CMakeLists.txt | grep 'ROBOTV_VERSION "' | cut -d' ' -f2 | tr -d '[")]')
    _pkg_version "$version" "$delta"
}

_main $@
