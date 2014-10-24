#!/bin/bash

cd "$(dirname "$0")"
DIR="$(pwd)"

if [ -z "$BASH_SOURCE" ]
then
    . "$(dirname "$DIR")/commons.sh"
else
    . "$(dirname "$BASH_SOURCE")/commons.sh"
fi

if [ -z "$BUILD_SOURCES" ]
then
    BUILD_CMD='create'
else
    BUILD_CMD='build'
fi

: ${EXCLUDE:=""}
BUILD_SCRIPTS="$(ls */build.sh)"
[ -z "$EXCLUDE" ] || BUILD_SCRIPTS="$(echo "$BUILD_SCRIPTS" | grep -Ev "($EXCLUDE)")"

export BUILD_CMD
export TARGET_PLATFORMS
export SKIP_UPDATE='true' SKIP_DEPENDS='true' SKIP_UPDATE_BASE='true'

_update_ppa_builder() {
    if [ "$DIR" == "$PPA_ROOT_DIR" ]
    then
        echo "Updating ppa-builder" 1>&2
        git "--git-dir=$PPA_BUILDER/.git" --work-tree="$PPA_BUILDER" pull > /dev/null
    fi
}
update() {
    if [ "$DIR" = "$PPA_ROOT_DIR" ]
    then
       _update_ppa_builder
       for i in $BUILD_SCRIPTS; do "./$i" update; done
       return 0
    fi
    
    for i in $BUILD_SCRIPTS
    do
        local dir="$(dirname "$i")"
        echo "Updating $(basename "$dir")"
        "./$i" update > /dev/null || (echo "Failed to update $i"; exit 1)
    done
}

clean() {
    if [ "$DIR" = "$PPA_ROOT_DIR" ]
    then
       for i in $BUILD_SCRIPTS; do "./$i" clean; done
       return 0
    fi
    
    for i in $BUILD_SCRIPTS
    do
        local dir="$(dirname "$i")"
        echo "Cleaning $(basename "$dir")"
        "./$i" clean > /dev/null
    done
}

check_updates() {
    if [ "$DIR" = "$PPA_ROOT_DIR" ]
    then
        for i in $BUILD_SCRIPTS
        do 
            local dir="$(dirname "$i")"
            echo "$(basename "$dir"):"
            "./$i" check_updates | while read i; do echo "    $i"; done
            echo
        done
        return 0
    fi
    
    (for i in $BUILD_SCRIPTS
    do
        local dir="$(dirname "$i")"
        echo "$(basename "$dir")|$("./$i" check_updates | grep -v "check_updates:")"
    done) | column -t -s '|'
}

version() {
    if [ "$DIR" = "$PPA_ROOT_DIR" ]
    then
        for i in $BUILD_SCRIPTS
        do 
            local dir="$(dirname "$i")"
            echo "$(basename "$dir"):"
            "./$i" version | while read i; do echo "    $i"; done
            echo
        done
        return 0
    fi
    
    (for i in $BUILD_SCRIPTS
    do
        local dir="$(dirname "$i")"
        echo "$(basename "$dir")|$("./$i" version | grep -v "version:")"
    done) | column -t -s '|'
}

build() {
    if [ "$DIR" = "$PPA_ROOT_DIR" ]
    then
        clean
        update
       _update_ppa_builder
       for i in $BUILD_SCRIPTS; do "./$i" build; done
       return 0
    fi

    for i in $BUILD_SCRIPTS
    do
        local dist="$("$i" check_updates | awk -F ':' '/Updates are available for/ {print $2}')"
        
        if [ ! -z "$dist" ]
        then
            local platf="$(for p in $dist; do echo -n "$p:amd64 $p:i386"; done)"
            echo "Building $(basename "$(dirname "$i")") for platforms$dist"
            TARGET_PLATFORMS="$platf" "$i" $BUILD_CMD upload
        else
            echo "No updates for $(basename "$(dirname "$i")")"
        fi
    done
}

TARGETS="build|check_updates|clean|update|version"
[ "$1" = '' ] && target='build' || target="$@"

for t in $target
do
    if echo "$t" | grep -Eq "^($TARGETS)\$"
    then
        $t
    else
        echo "Unknown target $t"
        echo "Usage: $0 <$TARGETS>"
    fi
done
