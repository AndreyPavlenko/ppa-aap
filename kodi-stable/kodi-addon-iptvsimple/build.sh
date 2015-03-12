#!/bin/bash

: ${SRC_URL:='https://github.com/AndreyPavlenko/xbmc-addon-iptvsimple.git'}
: ${REV:='kodi-helix'}
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='0'
    local v_major=$(git --git-dir="$SRC_DIR/.git" show $REV:configure.in | grep -E 'm4_define\(\[MAJOR\]' | awk '{print $2}' | tr -d ')')
    local v_minor=$(git --git-dir="$SRC_DIR/.git" show $REV:configure.in | grep -E 'm4_define\(\[MINOR\]' | awk '{print $2}' | tr -d ')')
    local v_micro=$(git --git-dir="$SRC_DIR/.git" show $REV:configure.in | grep -E 'm4_define\(\[MICRO\]' | awk '{print $2}' | tr -d ')')
    echo "$(_pkg_version ${v_major}.${v_minor}.${v_micro} $delta)"
}

_checkout() {
    _git_checkout "$1"
}

_main $@
