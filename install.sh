#!/bin/bash

set -eu

REPOS_PATH=${REPOS_PATH:-"${HOME}/repos"}

source common.sh

check_gopath

function install_cilium() {
    pushd "${GOPATH}/src/github.com/cilium/cilium"
    sudo make install DISABLE_ENVOY_INSTALLATION=1 PREFIX=/usr/local
    popd
}

function install_proxy() {
    pushd "${GOPATH}/src/github.com/cilium/proxy"
    sudo install -D -m0755 bazel-bin/cilium-envoy /usr/local/bin/cilium-envoy
    popd
}

function install_crio() {
    pushd "${GOPATH}/src/github.com/cri-o/cri-o"
    sudo make install
    sudo make install.systemd
    popd
}

function install_bpftool() {
    pushd "${REPOS_PATH}/bpf-next/tools/bpf/bpftool"
    sudo make install
    popd
}

function install_iproute2() {
    pushd "${REPOS_PATH}/iproute2-cilium"
    sudo make install
    popd
}

function install_systemd() {
    sudo install -D -m 0644 sysconfig/cilium /etc/sysconfig/cilium
    for service in cilium cilium-operator; do
        sudo install -D -m 0644 \
            systemd/${service}.service \
            /etc/systemd/system/${service}.service
    done
}

install_cilium
install_proxy
install_crio
install_bpftool
install_iproute2
install_systemd
