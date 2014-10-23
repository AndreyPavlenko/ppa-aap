#!/bin/bash

SRC_URL='git://anongit.freedesktop.org/vaapi/libva'
UNSUPPORTED_PLATFORMS='precise(:\w+)?'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='2'
    local major="$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | awk '/m4_define\(\[va_api_major_version\]/ {print $2}' | tr -d '[\[\]\)]')"
    local minor="$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | awk '/m4_define\(\[va_api_minor_version\]/ {print $2}' | tr -d '[\[\]\)]')"
    local micro="$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | awk '/m4_define\(\[libva_micro_version\]/ {print $2}' | tr -d '[\[\]\)]')"
    local pre="$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | awk '/m4_define\(\[libva_pre_version\]/ {print $2}' | tr -d '[\[\]\)]')"
    local version="$(($major + 1)).$(($minor - 32)).${micro}"
    [ -z "$pre" ] || version="$version.pre${pre}"
    _pkg_version "$version" "$delta"
}

_main $@
