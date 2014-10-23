#!/bin/bash
PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_URL='git://projects.vdr-developer.org/vdr-plugin-epgsearch.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='-1'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:epgsearch.c | awk -F '[=\\-"]' '/static const char VERSION/ {print $3}')
    _pkg_version "$version" "$delta"
}

_main $@
