#!/bin/bash

set -eu

REPOS_PATH=${REPOS_PATH:-"${HOME}/repos"}

source common.sh

function pull_repo() {
    local repo_path=$1
    local main_branch=${2:-"master"}

    pushd "${repo_path}"
    if [ $(git remote | grep upstream) ]; then
	git pull --rebase upstream ${main_branch}
    else
	git pull --rebase origin ${main_branch}
    fi
    popd
}

pull_repo "${GOPATH}/src/github.com/cilium/cilium"
pull_repo "${GOPATH}/src/github.com/cilium/proxy"
pull_repo "${GOPATH}/src/github.com/cri-o/cri-o"
pull_repo "${REPOS_PATH}/bpf-next"
pull_repo "${REPOS_PATH}/iproute2-cilium" "static-data"
