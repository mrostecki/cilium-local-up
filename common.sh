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
