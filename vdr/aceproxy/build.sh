#!/bin/bash

SRC_URL='https://github.com/AndreyPavlenko/aceproxy.git'
. "$(dirname "$0")/../commons.sh"

version() {
    local delta='237'
    local ci_count="$(_git_ci_count)"
    local sha="$(_git_sha)"
    local bs_ci_count="$(_bs_ci_count)"
    local version=$(git --git-dir="$SRC_DIR/.git" describe | awk -F '[v-]' '{print $2}')
    echo "${version}-$(($ci_count + $bs_ci_count + $delta))~${sha}"
}

_main $@
