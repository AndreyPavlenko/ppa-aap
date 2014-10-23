#!/bin/bash

SRC_URL='git://anongit.freedesktop.org/vaapi/intel-driver'
UNSUPPORTED_PLATFORMS='precise(:\w+)?'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='3'
    local major="$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | awk '/m4_define\(\[intel_driver_major_version\]/ {print $2}' | tr -d '[\[\]\)]')"
    local minor="$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | awk '/m4_define\(\[intel_driver_minor_version\]/ {print $2}' | tr -d '[\[\]\)]')"
    local micro="$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | awk '/m4_define\(\[intel_driver_micro_version\]/ {print $2}' | tr -d '[\[\]\)]')"
    local pre="$(git --git-dir="$SRC_DIR/.git" show $REV:configure.ac | awk '/m4_define\(\[intel_driver_pre_version\]/ {print $2}' | tr -d '[\[\]\)]')"
    local version="${major}.${minor}.${micro}"
    [ -z "$pre" ] || version="$version.pre${pre}"
    _pkg_version "$version" "$delta"
}

_main $@
