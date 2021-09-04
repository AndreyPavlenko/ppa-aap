#!/bin/bash

SRC_URL='https://github.com/CvH/vdr-plugin-wirbelscan.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='15'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:wirbelscan.c | awk '/const char \*VERSION/ {print $6}' | tr -d '[";\r]')
    _pkg_version "$version" "$delta"
}

# Converts scan-s2 list of transponders to the __sat_transponder structure
transponders() {
    sed -e 's/#.*//g; s/S1/SYS_DVBS/g; s/S2/SYS_DVBS2/g; s/ H / POLARIZATION_HORIZONTAL /g; s/ V / POLARIZATION_VERTICAL /g; s/ R / POLARIZATION_CIRCULAR_RIGHT /g; s/ L / POLARIZATION_CIRCULAR_LEFT /g; s/8PSK/PSK_8/g; s/\//_/g' \
    | grep -vE '^\s*$' \
    | awk '{print "{"$1 ", "$2/1000 ", "$3 ", "$4/1000 ", FEC_"$5 ", ROLLOFF_"$6 ", "$7 "},"}' \
    | sort -u
}

_main $@
