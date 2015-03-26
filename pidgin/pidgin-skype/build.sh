#!/bin/bash

PKG_EPOCH='2'
SRC_URL='http://github.com/EionRobb/skype4pidgin.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='9'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:libskypekit/libskypekit.h | awk -F '"' '/\/\* version \*\// {print $2}')
    _pkg_version "$version" "$delta"
}

_main $@
