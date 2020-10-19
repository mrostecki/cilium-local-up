#!/bin/bash

set -eu

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

function install_systemd() {
    for service in cilium cilium-operator; do
        sudo install -D -m 0644 \
            systemd/${service}.service \
            /etc/systemd/system/${service}.service
    done
}

install_cilium
install_proxy
install_systemd
