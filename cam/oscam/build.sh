#!/bin/bash

SRC_URL='http://repo.or.cz/oscam.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='2'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:globals.h | awk '/#define CS_VERSION/ {print $3}' | tr -d '["_\-a-z]')
    _pkg_version "$version" "$delta"
}

_main $@
