#!/bin/bash

set -eu

REPOS_PATH=${REPOS_PATH:-"${HOME}/repos"}
GIT_FORK_CILIUM=${GIT_FORK_CILIUM:-""}
GIT_FORK_PROXY=${GIT_FORK_PROXY:-""}
GIT_FORK_CRIO=${GIT_FORK_CRIO:-""}
GIT_FORK_KUBERNETES=${GIT_FORK_KUBERNETES:-""}
GIT_FORK_BPFNEXT=${GIT_FORK_BPFNEXT:-""}
GIT_FORK_IPROUTE2=${GIT_FORK_IPROUTE2:-""}

source common.sh

function clone_repo() {
    local dest="$1"
    local url_upstream="$2"
    local url_fork="$3"

    if [ -d "${dest}" ]; then
        echo "Repo $2 already cloned, skipping"
	return
    fi

    if [ -z "${url_fork}" ]; then
        git clone "${url_upstream}" "${dest}"
    else
        git clone "${url_fork}" "${dest}"
        pushd "${dest}"
        git remote add upstream "${url_upstream}"
	git fetch -t upstream
	popd
    fi
}



if [ ! -d "${REPOS_PATH}" ]; then
    mkdir -p "${REPOS_PATH}"
fi

clone_repo "${GOPATH}/src/github.com/cilium/cilium" "git@github.com:cilium/cilium.git" "${GIT_FORK_CILIUM}"
clone_repo "${GOPATH}/src/github.com/cilium/proxy" "git@github.com:cilium/proxy.git" "${GIT_FORK_PROXY}"
clone_repo "${GOPATH}/src/github.com/cri-o/cri-o" "git@github.com:cri-o/cri-o.git" "${GIT_FORK_CRIO}"
clone_repo "${GOPATH}/src/k8s.io/kubernetes" "git@github.com:kubernetes/kubernetes.git" "${GIT_FORK_KUBERNETES}"
clone_repo "${REPOS_PATH}/bpf-next" "git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git" "${GIT_FORK_BPFNEXT}"
clone_repo "${REPOS_PATH}/iproute2-cilium" "git@github.com:cilium/iproute2.git" "${GIT_FORK_IPROUTE2}"
