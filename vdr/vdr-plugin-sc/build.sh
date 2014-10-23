#!/bin/bash

SRC_URL='http://85.17.209.13:6100/sc'
REV='last(trunk)'
DEPENDS='mercurial'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='16'
    local ci_count=$(hg --cwd "$SRC_DIR" log --template "{node}\n" -r "..$REV" | wc -l)
    local sha=$(hg --cwd "$SRC_DIR" log -l 1 --template "{node|short}" -r "$REV")
    local version=$(hg --cwd "$SRC_DIR" cat -r "$REV" version.h | awk '/define SC_RELEASE/ { print $3 }' | tr -d '[";]')
    _pkg_version "$version" "$delta" "$ci_count" "$sha"
}

update() {
    update_vdr
    _hg_update "$SRC_URL"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _hg_changelog "${cur_version##*~}" "$REV" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

_checkout() {
    local dest="$1"
    _hg_checkout "$dest" "$REV" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

_main $@
