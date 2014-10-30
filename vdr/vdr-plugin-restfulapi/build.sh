#!/bin/bash

: ${SRC_URL:='https://github.com/yavdr/vdr-plugin-restfulapi.git'}
UNSUPPORTED_PLATFORMS='precise(:\w+)?'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='0'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:restfulapi.cpp | awk '/static const char \*VERSION */ { print $6 }' | sed -e 's/[";]//g')
    echo "$(_pkg_version $version $delta)"
}

_main $@
