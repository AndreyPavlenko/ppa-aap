#!/bin/bash

UNSUPPORTED_PLATFORMS='(precise|trusty|utopic)(:\w+)?'
: ${PPA_DIR:="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"}
. "$PPA_DIR/../commons.sh"

