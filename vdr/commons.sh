#!/bin/bash

: ${PPA_DIR:="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"}
. "$PPA_DIR/../commons.sh"

: ${VDR_SRC_DIR:="$SOURCES_DIR/vdr"}
#: ${VDR_SRC_URL:='http://git.tvdr.de/'}
: ${VDR_SRC_URL:='ftp://ftp.tvdr.de/vdr/'}
: ${VDR_REV:='origin/master'}

update() {
    _git_update "$SRC_URL"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _git_changelog "${cur_version##*~}" "$REV" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

_checkout() {
    local dest="$1"
    _git_checkout "$dest" "$REV" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

_vdr_version() {
    # git --git-dir="$VDR_SRC_DIR/.git" show $VDR_REV:config.h | grep 'define VDRVERSION' | awk '{print $3}' | tr -d '"'
    curl -s "$VDR_SRC_URL" | grep -oP '(?<=vdr-)[0-9\.]+(?=\.tar\.bz2)' | sort -Vur | head -1
}

_vdr_ci_count() {
    # _git_ci_count "$VDR_SRC_DIR/.git" "$VDR_REV"
    curl -s "$VDR_SRC_URL" | grep -oP '(?<=vdr-)[0-9\.]+(?=\.tar\.bz2)' | wc -l
}

_pkg_version() {
    local version="$1"
    local delta="${2:-"0"}"
    local ci_count="${3:-"$(_git_ci_count)"}"
    local sha="${4:-"$(_git_sha)"}"
    local bs_ci_count=$(_bs_ci_count)
    local vdr_ci_count=$(_vdr_ci_count)
    local common_delta="2"
    echo "${version}-$(($ci_count + $vdr_ci_count + $bs_ci_count + $delta + $common_delta))~${sha}"
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"
    
    if [ ! -d "$deb_dir" ]
    then
        cp -r "$DIR/debian" "$deb_dir"
        sed -i "s/#VDR_VERSION#/$(_vdr_version)/g" "$deb_dir/control"
    fi
    
    echo "$deb_dir"
}

_deb_dir_preprocess() {
    if [ "$2" == 'precise' ] || [ "$2" == 'trusty' ]
    then
        sed -i 's/Architecture: any/Architecture: amd64 i386/g' "$1/control"
    fi
}
