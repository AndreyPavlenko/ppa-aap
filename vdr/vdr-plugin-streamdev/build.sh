#!/bin/bash

SRC_URL='git://projects.vdr-developer.org/vdr-plugin-streamdev.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='2'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:common.c | awk -F '[=\\-"]' '/const *char *\*VERSION *=/ {print $3}')
    _pkg_version "$version" "$delta"
}

_main $@
