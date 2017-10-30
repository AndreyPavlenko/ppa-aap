#!/bin/bash

. "$(dirname "$0")/../commons.sh"
REV="$VDR_REV"

version() {
    local delta='0'
    _pkg_version "$(_vdr_version)" "$delta" 0
}

update() {
    echo
}

_checkout() {
    local dst="$1"
    local ver="$(_vdr_version)"
    local url="${VDR_SRC_URL}vdr-${ver}.tar.bz2"
    mkdir -p "$dst"
    curl -s "$url" | tar -C "$dst" -xj --strip 1
}

 _changelog() {
    echo "  * See HISTORY"
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/$2/debian"
    
    if [ ! -d "$deb_dir" ]
    then
    	mkdir -p "$BUILD_DIR/$2"
        cp -r "$DIR/debian" "$deb_dir"
        cp -r "$DIR/configs" "$deb_dir"
        cp -r "$DIR/scripts" "$deb_dir"
        [ -e "$DIR/patches/$2" ] && cp -r "$DIR/patches/$2" "$deb_dir/patches"
    fi

    echo "$deb_dir"
}

_main $@
