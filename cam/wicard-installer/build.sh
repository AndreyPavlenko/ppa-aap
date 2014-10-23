#!/bin/bash

. "$(dirname "$0")/../commons.sh"

WICARD_URL='https://satforumtmmmniae.onion.lt/download/index.php?directory=WICARD'
ALT_WICARD_URL='https://satforumtmmmniae.tor2web.org/download/index.php?directory=WICARD'
CURL_OPTS="-k -A 'Mozilla/5.0' -b disclaimer_accepted=true -b onion_cab_iKnowShit=1"

wicard_curl() {
    local dest="$BUILD_DIR/wicard.html"
    
    if [ ! -f "$dest" ]
    then
        mkdir -p "$BUILD_DIR"
        curl $CURL_OPTS "$WICARD_URL" 2>/dev/null > "$dest"
    fi
    
    cat "$dest"
}

version() {
    local delta='5'
    local bs_ci_count=$(git --git-dir="$DIR/../.git" log --format='%H' -- "$PKG_NAME" | wc -l)
    local version="$(wicard_curl | grep -Eo "directory=WICARD/wicardd-[a-zA-Z_0-9\.]+" | awk -F '[-_]' '{print $2}' | sort -g | tail -n 1)"
    echo "$version-$(($bs_ci_count + $delta))"
}

_checkout() {
    local dest="$1"
    mkdir -p "$dest"
    cp -r "$DIR/data"/* "$dest"
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"

    if [ ! -d "$deb_dir" ]
    then
        local dir="$(wicard_curl | grep -Eo "directory=WICARD/wicardd-[a-zA-Z_0-9\.]+" | sort -g | tail -n 1)"
        local wicard_dir_url="$(echo "$WICARD_URL" | sed "s;directory=WICARD;$dir;")"
        local alt_wicard_dir_url="$(echo "$ALT_WICARD_URL" | sed "s;directory=WICARD;$dir;")"

        cp -r "$DIR/debian" "$deb_dir"
        sed -i "s;@WICARD_URL_PATTERN@;$wicard_dir_url\&filename=@FILENAME@\&action=downloadfile;g" "$deb_dir/rules"
        sed -i "s;@ALT_WICARD_URL_PATTERN@;$alt_wicard_dir_url\&filename=@FILENAME@\&action=downloadfile;g" "$deb_dir/rules"
        sed -i "s;@CURL_OPTS@;$CURL_OPTS;g" "$deb_dir/postinst"
    fi

    echo "$deb_dir"
}

_changelog() {
    echo "  * Version $(version)"
}

update() {
    echo
}

_main $@
