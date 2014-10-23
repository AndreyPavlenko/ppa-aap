#!/bin/bash

FILES_URL='http://www.saunalahti.fi/~rahrenbe/vdr/iptv/files'
. "$(dirname "$0")/../commons.sh"

_curl_files() {
    local dest="$BUILD_DIR/index.php"
    
    if [ ! -f "$dest" ]
    then
        mkdir -p "$BUILD_DIR"
        curl -k "$FILES_URL/index.php" 2>/dev/null > "$dest"
    fi
    
    cat "$dest"
}

_iptv_version() {
	_curl_files | grep -oP 'vdr-iptv-.+?\.tgz' | sort -Vu | tail -1 | sed -r 's/vdr-iptv-|.tgz//g'
}

version() {
    local delta='18'
    local bs_ci_count=$(_bs_ci_count)
    local vdr_ci_count=$(_vdr_ci_count)
    local version=$(_iptv_version)
    echo "$version-$(($bs_ci_count + $vdr_ci_count + $delta))"
}

_download() {
	local v="$(_iptv_version)"
    local filename="vdr-iptv-$v.tgz"
	local dest="$1/$filename"
	[ -f "$dest" ] || curl -k "$FILES_URL/$filename" 2>/dev/null > "$dest"
	echo "$dest"
}

_checkout() {
    local dest="$1"
    local tgz="$(_download "$BUILD_DIR")"
    mkdir -p "$dest"
    tar xzf "$tgz" -C "$dest" --strip-components=1
}

_changelog() {
    echo "  * Version $(version)"
}

update() {
    echo
}

_main $@
