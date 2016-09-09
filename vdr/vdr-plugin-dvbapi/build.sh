#!/bin/bash

SRC_URL='https://github.com/manio/vdr-plugin-dvbapi.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='14'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:DVBAPI.h | awk '/#define VERSION / {print $3}' | tr -d '[";]')
    _pkg_version "$version" "$delta"
}

_main $@
