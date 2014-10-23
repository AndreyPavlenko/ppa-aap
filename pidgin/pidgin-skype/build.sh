#!/bin/bash

PKG_EPOCH='2'
SRC_URL='http://skype4pidgin.googlecode.com/svn/trunk'
DEPENDS='subversion'
. "$(dirname "$0")/../commons.sh"
REV=''

version() {
    if [ -z "$REV" ]
    then
        local rev="$(_svn_rev)"
    else
        local rev="$REV"
    fi

    local delta='0'
    local version=$(svn cat -r $rev "$SRC_DIR/libskypekit/libskypekit.h" | awk -F '"' '/\/\* version \*\// {print $2}')
    _pkg_version "$version" "$delta" "$rev" "r$rev"
}

update() {
    _svn_update "$SRC_URL"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _svn_changelog "${cur_version##*~}" "$REV" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

_checkout() {
    local dest="$1"
    _svn_checkout "$dest" "$SRC_DIR"
}

_main $@
