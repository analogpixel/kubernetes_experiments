#!/bin/false "This script should be sourced in a shell, not executed directly"

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

export KUBECONFIG=${HOME}/.kind_config
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\] \[\033[33;1m\]\w\[\033[m\] KIND $ "
