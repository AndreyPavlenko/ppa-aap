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

: ${EXCLUDE:="wicard|ffdecsa"}
BUILD_SCRIPTS="$(ls */build.sh)"
[ -z "$EXCLUDE" ] || BUILD_SCRIPTS="$(echo "$BUILD_SCRIPTS" | grep -Ev "($EXCLUDE)")"

export BUILD_CMD
export TARGET_PLATFORMS
export SKIP_UPDATE='true' SKIP_DEPENDS='true' SKIP_UPDATE_BASE='true'

branchname() {
    cd "$1" && git rev-parse --abbrev-ref HEAD
}

_update_ppa_builder() {
    if [ "$DIR" == "$PPA_ROOT_DIR" ]
    then
        echo "Updating ppa-builder ($(branchname "$dir"))" 1>&2
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
       for i in $BUILD_SCRIPTS; do "./$i" check_updates; done
       return 0
    fi
    
    (for i in $BUILD_SCRIPTS
    do
        local dir="$(dirname "$i")"
        echo "$(basename "$dir")|$(branchname "$dir")|$("./$i" check_updates | grep -v "check_updates:")"
    done) | column -t -s '|'
}

version() {
    if [ "$DIR" = "$PPA_ROOT_DIR" ]
    then
       for i in $BUILD_SCRIPTS; do "./$i" version; done
       return 0
    fi
    
    (for i in $BUILD_SCRIPTS
    do
        local dir="$(dirname "$i")"
        echo "$(basename "$dir")|$(branchname "$dir")|$("./$i" version | grep -v "version:")"
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

TARGETS=$(declare -F | cut -d" " -f3 | grep -Eo '^ *[a-z]\w+' | tr -d '[ \t\(\)]' | sort | tr '\n' '|' | head -c -1)
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
