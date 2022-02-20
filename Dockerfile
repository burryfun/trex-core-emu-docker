FROM centos:8

RUN sed -i -e '/^mirrorlist=http:\/\//d' -e 's/^# *baseurl=http:\/\/mirror.centos.org/baseurl=http:\/\/vault.centos.org/' /etc/yum.repos.d/CentOS-*.repo


RUN yum update -y && yum upgrade -y && yum install -y \
    git \
    gcc-c++

WORKDIR /usr/local
RUN git clone https://github.com/burryfun/trex-core.git \
    && git clone https://github.com/cisco-system-traffic-generator/trex-emu.git

RUN yum install -y \
    python3 \
    zlib-devel \
    wget \
    vim \
    net-tools \
    sudo

WORKDIR /usr/local/trex-core/linux_dpdk
RUN ./b configure && ./b

RUN wget https://golang.org/dl/go1.17.1.linux-amd64.tar.gz \
    && tar -C /usr/local -xf go1.17.1.linux-amd64.tar.gz

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "export PATH=$PATH:/usr/local/go/bin" > /etc/profile \
    && source /etc/profile

RUN yum install -y pkg-config

WORKDIR /usr/local/trex-emu/scripts
RUN ./utility_script build -v

RUN rm /usr/local/trex-core/scripts/trex-emu
COPY trex-emu /usr/local/trex-core/scripts
RUN chmod +x /usr/local/trex-core/scripts/trex-emu 

COPY trex_cfg.yaml /etc/
COPY tcp_emu/ipv4_profile.py /usr/local/trex-core/scripts/emu

RUN rm /usr/local/trex-core/scripts/astf/nginx_wget.py
COPY tcp_emu/nginx_wget.py /usr/local/trex-core/scripts/astf

WORKDIR /usr/local/trex-core/scripts

RUN ln -s automation/trex_control_plane/interactive/trex/examples/stl/stl_pppoe_example.py start_pppoe
RUN ln -s automation/trex_control_plane/interactive/trex/examples/stl/cfg/settings.ini settings.ini
