FROM ubuntu:16.04

MAINTAINER Wenbin Hou <catchyrime@outlook.com>

SHELL [ "/bin/bash", "-c" ]

ENV DEBIAN_FRONTEND noninteractive
ARG CLANG_VERSION

RUN \
    set -xe; \
    shopt -s dotglob; \
    \
    if [ -z "$CLANG_VERSION" ]; then \
        echo "Argument CLANG_VERSION is requried"; \
        exit 1; \
    fi; \
    \
    apt-get -yq update || true; \
    apt-get -yq install apt-utils; \
    apt-get -yq install curl wget ca-certificates; \
    \
    echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" >/etc/apt/sources.list.d/clang.list; \
    echo "#deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" >>/etc/apt/sources.list.d/clang.list; \
    echo "# 6.0" >>/etc/apt/sources.list.d/clang.list; \
    echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" >>/etc/apt/sources.list.d/clang.list; \
    echo "#deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" >>/etc/apt/sources.list.d/clang.list; \
    echo "# 7" >>/etc/apt/sources.list.d/clang.list; \
    echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main" >>/etc/apt/sources.list.d/clang.list; \
    echo "#deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main" >>/etc/apt/sources.list.d/clang.list; \
    \
    wget -O- -nv https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -; \
    apt-get -yq update || true; \
    apt-get -yq install -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
        clang-"$CLANG_VERSION" \
        curl golang-go make vim texinfo gdb \
        python-dev python-pip python3-dev python3-pip python3-venv; \
    \
    ln -sfT /usr/bin/clang-[0-9]* /usr/bin/clang; \
    ln -sfT /usr/bin/clang++-[0-9]* /usr/bin/clang++; \
    ln -sfT /usr/bin/clang /usr/bin/cc; \
    ln -sfT /usr/bin/clang++ /usr/bin/c++; \
    \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf ~/.cache;


#
# Install ccache
#
RUN \
    set -xe; \
    cd /tmp; \
    wget -q https://www.samba.org/ftp/ccache/ccache-3.6.tar.gz; \
    tar -xf ccache-3.6.tar.gz; \
    rm ccache-3.6.tar.gz; \
    \
    pushd ccache-3.6; \
    ./configure; \
    make -j "$(nproc)"; \
    make install; \
    popd; \
    rm -rf ccache-3.6; \
    \
    mkdir -p /opt/more/ccache; \
    ln -sfT "$(which ccache)" /opt/more/ccache/clang; \
    ln -sfT "$(which ccache)" /opt/more/ccache/clang++; \
    ln -sfT "$(which ccache)" /opt/more/ccache/cc; \
    ln -sfT "$(which ccache)" /opt/more/ccache/c++; \
    mkdir -p /ccache;

ENV CCACHE_DIR "/ccache"
ENV CCACHE_NLEVELS "4"
ENV CCACHE_COMPILERCHECK "content"
ENV CCACHE_NOCOMPRESS yes
ENV CCACHE_DIRECT yes
#ENV CCACHE_MAXSIZE 256G
ENV CCACHE_SLOPPINESS file_macro,locale,time_macros

ENV PATH "/opt/more/ccache:$PATH"

