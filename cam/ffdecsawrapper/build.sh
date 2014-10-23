#!/bin/bash

SRC_URL='https://github.com/bas-t/ffdecsawrapper.git'
REV='origin/oldstable'
. "$(dirname "$0")/../commons.sh"

version() {
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:Makefile | awk -F '[= ]' '/VERSION = / {print $4}')
    _pkg_version "$version"
}

update() {
    _git_update "$SRC_URL"
}

_checkout() {
    local dest="$1"
    _git_checkout "$dest" "$REV" "$SRC_DIR"
}


_changelog() {
    local cur_version="$(_cur_version "$1")"
    _git_changelog "${cur_version##*~}" "$REV" "$SRC_DIR"
}

_main $@
