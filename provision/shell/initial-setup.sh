#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

VAGRANT_CORE_FOLDER=$(echo "$1")

OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
CODENAME=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" CODENAME)


if [[ ! -d '/.provision-stuff' ]]; then
    mkdir '/.provision-stuff'
    echo 'Created directory /.provision-stuff'
fi

touch '/.provision-stuff/vagrant-core-folder.txt'
echo "${VAGRANT_CORE_FOLDER}" > '/.provision-stuff/vagrant-core-folder.txt'

if [[ -f '/.provision-stuff/initial-setup-base-packages' ]]; then
    exit 0
fi

if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
    echo 'Running initial-setup apt-get update'
    apt-get update >/dev/null
    echo 'Finished running initial-setup apt-get update'

    echo 'Installing git'
    apt-get -y install git-core >/dev/null
    echo 'Finished installing git'

    if [[ "${CODENAME}" == 'lucid' || "${CODENAME}" == 'precise' ]]; then
        echo 'Installing basic curl packages'
        apt-get -y install libcurl3 libcurl4-gnutls-dev curl >/dev/null
        echo 'Finished installing basic curl packages'
    fi

    echo 'Installing build-essential package'
    apt-get -y install build-essential >/dev/null
    echo 'Finished installing build-essential packages'
fi

touch '/.provision-stuff/initial-setup-base-packages'
