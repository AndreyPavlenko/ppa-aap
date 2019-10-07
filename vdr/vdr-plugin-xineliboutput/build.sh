#!/bin/bash

SRC_URL='https://github.com/vdr-projects/vdr-plugin-xineliboutput.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='1'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:xineliboutput.c | awk -F '[=\\-"]' '/const *char *\*VERSION *=/ {print $3}')
    _pkg_version "$version" "$delta"
}

_main $@
