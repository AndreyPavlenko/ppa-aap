#!/bin/bash
set -e

DEPENDS=''
SERVICE_URL='http://services.gradle.org/versions/current'
DEPENDS='curl wget jshon'

. "$(dirname "$0")/../commons.sh"

_gradle_ver() {
    [ -z "$GRADLE_VER" ] && GRADLE_VER=$(curl "$SERVICE_URL" 2>/dev/null | jshon -e version -u)
    echo $GRADLE_VER
}

_gradle_url() {
    [ -z "$DOWNLOAD_URL" ] && DOWNLOAD_URL=$(curl "$SERVICE_URL" 2>/dev/null | jshon -e downloadUrl -u)
    echo $DOWNLOAD_URL
}

version() {
    local delta='0'
    local bs_ci_count=$(_bs_ci_count)
    echo "$(_gradle_ver)"-"$(($bs_ci_count + $delta))"
}

_checkout() {
	wget --spider "$(_gradle_url)"
    mkdir "$1"
}

_changelog() {
    echo "  * Gradle version $(_gradle_ver)"
}

update() {
    echo
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"

    if [ ! -d "$deb_dir" ]
    then
        local ver="$(_gradle_ver)"
        local url="$(_gradle_url)"
        cp -r "$DIR/debian" "$deb_dir"
        sed -i "s#@URL@#$url#; s#@VERSION@#$ver#" "$deb_dir/postinst"
        sed -i "s#@VERSION@#$ver#" "$deb_dir/postrm"
    fi

    echo "$deb_dir"
}

_main $@
