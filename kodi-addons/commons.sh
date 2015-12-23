#!/bin/bash

: ${PPA_DIR:="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"}
PPA_DEPENDS="deb http://ppa.launchpad.net/team-xbmc/unstable/ubuntu #DISTRIB# main|\
deb http://ppa.launchpad.net/team-xbmc/xbmc-ppa-build-depends/ubuntu #DISTRIB# main"
. "$PPA_DIR/../commons.sh"
