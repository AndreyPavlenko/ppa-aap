#!/bin/bash

SRC_URL='https://github.com/pipelka/vdr-plugin-xvdr.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='7'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:src/xvdr/xvdr.h | grep 'static const char \*VERSION *=' | awk '{ print $6 }' | tr -d '[";]')
    _pkg_version "$version" "$delta"
}

_main $@
