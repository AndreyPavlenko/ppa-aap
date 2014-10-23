#!/bin/bash

: ${PKG_EPOCH:='2'}
: ${SRC_URL:='https://github.com/xbmc/xbmc.git'}
. "$(dirname "$0")/../commons.sh"


version() {
    local delta='0'
    local v_major=$(git --git-dir="$SRC_DIR/.git" show $REV:version.txt | awk '/VERSION_MAJOR/ {print $2}')
    local v_minor=$(git --git-dir="$SRC_DIR/.git" show $REV:version.txt | awk '/VERSION_MINOR/ {print $2}')
    echo "$(_pkg_version ${v_major}.${v_minor} $delta)"
}

_checkout() {
     local src="$1"
    _git_checkout "$src"
    cd "$src/tools/depends/target/ffmpeg"
    chmod 777 autobuild.sh
    ./autobuild.sh -d
}

_main $@
