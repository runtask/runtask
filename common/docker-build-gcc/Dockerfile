ARG GCC_VERSION


FROM gcc:${GCC_VERSION}

MAINTAINER Wenbin Hou <catchyrime@outlook.com>

SHELL [ "/bin/bash", "-c" ]

ENV DEBIAN_FRONTEND noninteractive


# Copy contents of "go" to /opt/more/go
RUN mkdir -p /opt/more/go
COPY go /opt/more/go
ENV PATH "/opt/more/go/bin:$PATH"


RUN \
    set -xe; \
    shopt -s dotglob; \
    \
    if [ -z "$GCC_VERSION" ]; then \
        echo "ERROR: GCC_VERSION is requried"; \
        exit 1; \
    fi; \
    \
    apt-get -yq update || true; \
    apt-get -yq install apt-utils; \
    \
    apt-get -yq install \
        wget curl make realpath vim texinfo gdb \
        python-dev python-pip python3-dev python3-pip; \
    apt-get -yq install openjdk-8-jdk || ( \
        echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" >>/etc/apt/sources.list; \
        echo 'Acquire::Check-Valid-Until "false";' >>/etc/apt/apt.conf; \
        apt-get -yq update || true; \
        apt-get -yq install -t jessie-backports openjdk-8-jdk; \
	); \
    \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf ~/.cache; \
    \
    cd /opt/more; \
    wget https://www.apache.org/dist/ant/binaries/apache-ant-1.9.14-bin.tar.gz; \
    tar -xf apache-ant-1.9.14-bin.tar.gz; \
    rm apache-ant-1.9.14-bin.tar.gz; \
    ln -sfT apache-ant-1.9.14 apache-ant

ENV PATH "/opt/more/apache-ant/bin:$PATH"


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
    ln -sfT "$(which ccache)" /opt/more/ccache/gcc; \
    ln -sfT "$(which ccache)" /opt/more/ccache/g++; \
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

