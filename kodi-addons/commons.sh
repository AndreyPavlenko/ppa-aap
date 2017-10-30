#!/bin/bash

: ${PPA_DIR:="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"}
PPA_DEPENDS="deb http://ppa.launchpad.net/team-xbmc/xbmc-nightly/ubuntu #DISTRIB# main"
. "$PPA_DIR/../commons.sh"
