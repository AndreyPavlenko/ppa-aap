#!/bin/bash

SRC_URL='git://projects.vdr-developer.org/vdr-plugin-upnp.git'
. "$(dirname "$0")/../commons.sh"

version() {
	local delta='-21'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:upnp.h | awk -F '[=\\-"]' '/static const *char *\*VERSION *=/ {print $3}')
    _pkg_version "$version" "$delta"
}

_main $@
