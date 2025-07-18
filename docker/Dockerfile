# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the locale
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

# Use https for apt repositories
RUN apt update && \
    apt install -y --no-install-recommends apt-transport-https ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN sed -i 's|http|https|g' /etc/apt/sources.list 

# Set the timezone to France
ENV TZ=Europe/Paris
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    git \
    sudo \
    wget \
    curl \
    vim \
    software-properties-common \
    python3 \
    python3-pip \
    python3-dev \
    libpcre3-dev \
    pkg-config \
    libfl-dev \
    bison \  
    flex \
    gperf \
    clang \
    g++ \
    zlib1g-dev \
    openssh-server \
    gnupg \
    autoconf \
    automake \
    libtool \
    tree \
    openjdk-17-jdk \
    lcov \
    libpcre2-dev \
    gcc-riscv64-unknown-elf \
    help2man && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install SWIG (4.2.1)d
RUN git clone https://github.com/swig/swig.git -b v4.2.1 --depth=1 /tmp/swig && \
    cd /tmp/swig && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/swig

# Set up Kitware repository and install the latest CMake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
    gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | \
    tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && \
    apt-get install -y --no-install-recommends cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Verilator (5.0 series latest version, e.g. v5.018)
RUN git clone https://github.com/verilator/verilator -b v5.018 --depth=1 /tmp/verilator && \
    cd /tmp/verilator && \
    autoconf && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && make test && \
    make install && \
    rm -rf /tmp/verilator

# Verify Dependency installations
RUN swig -version && \
    cmake --version && \
    verilator --version && \
    java --version && \
    python3 --version

# Install Picker
ENV BUILD_XSPCOMM_SWIG=python,java
RUN mkdir /workspace && \
    cd /workspace && \
    cd /workspace && git clone https://github.com/XS-MLVP/picker.git  && \
    wget https://github.com/chipsalliance/verible/releases/download/v0.0-3979-g786edf03/verible-v0.0-3979-g786edf03-linux-static-x86_64.tar.gz && \
    tar -xzf verible-v0.0-3979-g786edf03-linux-static-x86_64.tar.gz -C /usr/local/ --strip-components=1 && \
    rm verible-v0.0-3979-g786edf03-linux-static-x86_64.tar.gz && \
    cd /workspace/picker && git checkout b3da72f && make init && \
    make && \
    make install && \
    make clean && \
    chmod 755 /usr/local/bin -R 

# set user and password
RUN useradd -m -s /bin/bash user && \
    echo "user:user" | chpasswd && \
    adduser user sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    chown user:user -R /workspace && \
    chmod 755 /workspace

# Set SSH autostart
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's|#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config && \
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication yes|' /etc/ssh/sshd_config && \
    sed -i 's|#PermitEmptyPasswords no|PermitEmptyPasswords yes|' /etc/ssh/sshd_config && \
    sed -i 's|#Port 22|Port 51202|' /etc/ssh/sshd_config && \
    # only listen on localhost
    sed -i 's|#ListenAddress|ListenAddress 127.0.0.1 #|' /etc/ssh/sshd_config && \
    ssh-keygen -A

# Switch to the new user
USER user

RUN pip3 install toffee-test filelock && \
    pip3 install pytoffee==0.2.3 
 
# Set the default shell to bash
SHELL ["/bin/bash", "-c"]
# Set working directory
WORKDIR /workspace
