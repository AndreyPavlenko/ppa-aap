#!/bin/bash

: ${SRC_URL:='git://projects.vdr-developer.org/vdr-plugin-epgfixer.git'}
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='0'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:epgfixer.c | awk '/static const char VERSION/ { print $6 }' | sed -e 's/[";]//g')
    echo "$(_pkg_version $version $delta)"
}

_main $@
