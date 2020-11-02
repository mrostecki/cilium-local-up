#!/bin/bash

function err_undef_var() {
    printf "Please set the %s variable\n" "$*" >&2
    exit 1
}

function check_gopath() {
    if [ -z "${GOPATH}" ]; then
        err_undef_var "GOPATH"
    fi
}

function wait_for_k8s() {
    timeout 5m bash -c "until kubectl get all &>/dev/null; do echo 'Waiting for Kubernetes...'; sleep 10; done"
}
