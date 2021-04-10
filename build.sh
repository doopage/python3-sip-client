#!/usr/bin/env bash
set -ex

if [[ ! "${VERSION}" ]]; then
    exit 1
fi

archive_url="http://download.ag-projects.com/SipSimpleSDK/Python3/python3-sipsimple-${VERSION}.tar.gz"

tmp_path="tmp"
tmp_archive_path="${tmp_path}/sip_simple_sdk.tar.gz"
tmp_source_path="${tmp_path}/sip_simple_sdk"

mkdir -p "${tmp_path}"

if [[ ! -f "${tmp_archive_path}" ]]; then
    wget -O "${tmp_archive_path}" -q "${archive_url}"
fi

if [[ ! -d "${tmp_source_path}" ]]; then
    mkdir -p "${tmp_source_path}"
    tar -xf "${tmp_archive_path}" --strip-components=1 -C "${tmp_source_path}"
fi

cd "${tmp_source_path}"

if [[ "$(which apt)" ]]; then
    # Common
    sudo apt-get install -y \
        devscripts \
        debhelper \
        openssl \
        ffmpeg \
        libasound2-dev \
        libssl-dev \
        libsqlite3-dev

    # Audio
    sudo apt-get install -y \
        libv4l-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        libswresample-dev \
        libx264-dev \
        libvpx-dev \
        libavcodec-dev

    # Python3
    sudo apt-get install -y \
        python3-setuptools \
        python3-dev
fi

if [[ "$(which pip3)" ]]; then
    pip3 install Cython
    pip3 install .
fi

if [[ -f "./makedeb.sh" ]]; then
    chmod +x ./makedeb.sh
    ./makedeb.sh
fi

if [[ "$(which dpkg)" ]]; then
    sudo dpkg -i *.deb
fi
