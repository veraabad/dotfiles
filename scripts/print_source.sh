#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   06/09/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: 06/09/2020

info() {
    # shellcheck disable=SC2059
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
    # shellcheck disable=SC2059
    printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
    # shellcheck disable=SC2059
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
    # shellcheck disable=SC2059
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}
