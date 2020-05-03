#!/bin/bash

#SRC_URL='git+ssh://mob@repo.or.cz/srv/git/siplcs.git'
#REV='origin/fixer'
SRC_URL='https://github.com/tieto/sipe.git'
REV='origin/launchpad-next'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='1'
    local version="$(git --git-dir="$SRC_DIR/.git" show $REV:VERSION)"
    _pkg_version "$version" "$delta"
}

_deb_dir() {
    local src="$1"
    local dist="$2"
    local deb_dir="$BUILD_DIR/$dist/debian"
    local depends='libfarstream-0.2-dev, libgstreamer1.0-dev, libgstreamer-plugins-base1.0-dev, libnice-dev, flex'
    
    mkdir -p "$deb_dir"
    cp -r "$src/contrib/debian"/* "$deb_dir"
    cp -r "$DIR/debian"/* "$deb_dir"
    sed -i "s/^Maintainer:.*\$/Maintainer: $MAINTAINER/; s/^Build-Depends:/Build-Depends: $depends, /" \
        "$deb_dir/control"
    
    echo "$deb_dir"
}

_main $@
