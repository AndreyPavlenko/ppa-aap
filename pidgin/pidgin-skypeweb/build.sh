#!/bin/bash

SRC_URL='http://skype4pidgin.googlecode.com/svn/trunk'
SRC_DIR_NAME='pidgin-skype'
RELATIVE_SRC_DIR='skypeweb'
DEPENDS='subversion'
. "$(dirname "$0")/../commons.sh"
REV=''

_rev() {
    if [ -z "$REV" ]
    then
        _svn_rev "$SRC_DIR/$RELATIVE_SRC_DIR"
    else
        echo "$REV"
    fi
}

version() {
    local rev="$(_rev)"
    local delta='0'
    local version=$(svn cat -r $rev "$SRC_DIR/skypeweb/libskypeweb.h" | awk -F '"' '/#define SKYPEWEB_PLUGIN_VERSION/ {print $2}')
    _pkg_version "$version" "$delta" "$rev" "r$rev"
}

update() {
    _svn_update "$SRC_URL"
}

_changelog() {
    local rev="$(_rev)"
    local cur_version="$(_cur_version "$1")"
    _svn_changelog "${cur_version##*~}" "$rev" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

_checkout() {
    local dest="$1"
    _svn_checkout "$dest" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

_main $@
