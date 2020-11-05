#!/bin/bash

set -eu

REPOS_PATH=${REPOS_PATH:-"${HOME}/repos"}
skip_envoy=false

while :; do
    case "${1-}" in
        --skip-envoy)
            skip_envoy=true
            break
            ;;
        *)
            break
    esac

    shift
done

source common.sh

check_gopath

function build_cilium() {
    pushd "${GOPATH}/src/github.com/cilium/cilium"
    make -j$(nproc) build
    popd
}

function build_proxy() {
    pushd "${GOPATH}/src/github.com/cilium/proxy"
    bazel build \
        --local_cpu_resources=HOST_CPUS*.65 \
        --experimental_local_memory_estimate \
        //:cilium-envoy
    popd
}

function build_crio() {
    pushd "${GOPATH}/src/github.com/cri-o/cri-o"
    make -j$(nproc)
    popd
}

function build_bpftool() {
    pushd "${REPOS_PATH}/bpf-next/tools/bpf/bpftool"
    make -j$(nproc)
    popd
}

function build_iproute2() {
    pushd "${REPOS_PATH}/iproute2-cilium"
    make -j$(nproc) CC=gcc-7
    popd
}

build_cilium
if ! $skip_envoy; then
    build_proxy
fi
build_crio
build_bpftool
build_iproute2
