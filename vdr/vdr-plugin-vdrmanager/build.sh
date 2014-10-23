#!/bin/bash

SRC_URL='git://projects.vdr-developer.org/vdr-manager.git'
RELATIVE_SRC_DIR='vdr-vdrmanager'
. "$(dirname "$0")/../commons.sh"

version() {
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:vdr-vdrmanager/vdrmanager.cpp | awk -F '[=\\-"]' '/const *char *\*VERSION *=/ {print $3}')
    _pkg_version "$version"
}

_main $@
