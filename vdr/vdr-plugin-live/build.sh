#!/bin/bash
SRC_URL='git://projects.vdr-developer.org/vdr-plugin-live.git'
. "$(dirname "$0")/../commons.sh"

version() {
	local delta='0'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:setup.h | awk -F '[ "]' '/\#define LIVEVERSION / { print $4 }')
    _pkg_version "$version" "$delta"
}


_deb_dir() {
	local src="$1"
    local deb_dir="$BUILD_DIR/debian"
    
    if [ ! -d "$deb_dir" ]
    then
        cp -r "$DIR/debian" "$deb_dir"
        cp -r "$src/debian/plugin.live.conf" "$deb_dir"
        sed -i "s/#VDR_VERSION#/$(_vdr_version)/g" "$deb_dir/control"
    fi
    
    echo "$deb_dir"
}

_main $@
