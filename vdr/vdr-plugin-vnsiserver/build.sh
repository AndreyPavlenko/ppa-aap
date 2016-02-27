#!/bin/bash

SRC_URL='https://github.com/FernetMenta/vdr-plugin-vnsiserver'
PKG_EPOCH='1'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='411'
    local version=$(git --git-dir="$SRC_DIR/.git" show "$REV:vnsi.h" | awk '/static const char \*VERSION *=/ { print $6 }' | tr -d '[";]')
    _pkg_version "$version" "$delta"
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"
    
    if [ ! -d "$deb_dir" ]
    then
        local makefile="$1/Makefile"
        local name="$(awk '/PLUGIN *= */ {print $3}' "$makefile")"
        cp -r "$DIR/debian" "$deb_dir"
        sed -i "s/vnsiserver/$name/g" "$deb_dir/links"
        sed -i "s/#VDR_VERSION#/$(_vdr_version)/g" "$deb_dir/control"
    fi

    echo "$deb_dir"
}

_main $@
