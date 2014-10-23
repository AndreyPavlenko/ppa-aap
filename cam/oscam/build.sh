#!/bin/bash

SRC_URL='http://www.streamboard.tv/svn/oscam/trunk'
DEPENDS='subversion'
. "$(dirname "$0")/../commons.sh"
REV=''

version() {
    if [ -z "$REV" ]
    then
        local rev="$(svn info --xml "$SRC_DIR" | tr '\n' ' ' | grep -oE '<commit\s+revision\s*=\s*"[0-9]+"\s*>' | grep -oE '[0-9]+')"
    else
        local rev="$REV"
    fi

    local delta='227'
    local version=$(svn cat -r $rev "$SRC_DIR/globals.h" | awk '/#define\s+CS_VERSION/ {print $3}' | tr -d '["_\-a-z]')
    _pkg_version "$version" "$delta" "$rev" "r$rev"
}

update() {
    _svn_update "$SRC_URL"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _svn_changelog "${cur_version##*~}" "$REV" "$SRC_DIR"
}

_checkout() {
    local dest="$1"
    _svn_checkout "$dest" "$SRC_DIR"
}

_main $@
