#!/bin/bash

SRC_URL='http://github.com/EionRobb/skype4pidgin.git'
SRC_DIR_NAME='pidgin-skype'
RELATIVE_SRC_DIR='skypeweb'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='9'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:skypeweb/libskypeweb.h | awk -F '"' '/#define SKYPEWEB_PLUGIN_VERSION/ {print $2}')
    _pkg_version "$version" "$delta"
}

_main $@
