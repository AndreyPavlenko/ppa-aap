#!/bin/bash
set -e

: ${DIR:="$(cd "$(dirname "$0")" && pwd)"}
: ${PPA_ROOT_DIR:="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"}
: ${RELPATH:="$(echo ${DIR#$PPA_ROOT_DIR/})"}

: ${PKG_NAME:="$(basename "$DIR")"}
: ${PPA:="$(basename "$(dirname "$DIR")")"}
: ${PPA_URL:='http://ppa.launchpad.net/aap'}

: ${DEPENDS:='git'}

[ ! -f "$HOME/.build.config" ] || . "$HOME/.build.config" && IGNORE_GLOBAL_CONFIG='true'
for i in ${BASH_SOURCE[@]}; do i="$(dirname "$i")"; [ -f "$i/build.config" ] && . "$i/build.config"; done
[ ! -f "$DIR/build.config" ]   || . "$DIR/build.config" && IGNORE_CONFIG='true'

: ${PPA_BUILDER:="$PPA_ROOT_DIR/ppa-builder"}
: ${PPA_BUILDER_URL:='https://github.com/AndreyPavlenko/ppa-builder.git'}

[ -d "$PPA_BUILDER" ] || git clone "$PPA_BUILDER_URL" "$PPA_BUILDER"
. "$PPA_BUILDER/build.sh"

update() {
    _git_update "$SRC_URL"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _git_changelog "${cur_version##*~}" "$REV"
}

_git_bs_ci_count() {
    local path="${1:-"$RELPATH"}"
    git --git-dir="$PPA_ROOT_DIR/.git" log --format='%H' -- "$path" | wc -l
}

_git_ci_count() {
    local git_dir="${1:-"$SRC_DIR/.git"}"
    local rev="${2:-"$REV"}"
    git --git-dir="$git_dir" log --format='%H' $rev | wc -l
}

_git_sha() {
    local git_dir="${1:-"$SRC_DIR/.git"}"
    local rev="${2:-"$REV"}"
    git --git-dir="$git_dir" log --format='%h' -n1 $rev
}

_git_version() {
    local version="$1"
    local delta="${2:-a}"
    echo "${version}-$(($(_git_ci_count) + $(_git_bs_ci_count) + $delta))~$(_git_sha)"
}
