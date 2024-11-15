FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

RUN apt-get update && apt-get upgrade -y 
# Update the package list and install necessary dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    cmake \
    build-essential \
    pkg-config \
    libssl-dev \
    libgmp-dev \
    libffi-dev \
    libsodium-dev \
    nasm \
    git \
    awscli \
    gcc \
    nodejs \
    npm \
    curl \
    m4 \
    python3 \
    python3-pip \
    python3-dev \
    wget \
    software-properties-common \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3 as the default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Node install
RUN npm install -g n 
RUN n 22
RUN npm install -g yarn snarkjs


RUN git clone https://github.com/zkemail/email-tx-builder.git
WORKDIR /email-tx-builder/packages/prover
RUN pip install -r requirements.txt
RUN cp ./circom_proofgen.sh /root
# RUN cp ./email_auth_with_body_parsing_with_qp_encoding /root
WORKDIR /root
RUN ls /root
RUN mkdir params
WORKDIR /root/params

RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_prod1.zkey --output ./email_auth.zkey
# RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth.wasm --output ./email_auth.wasm
RUN mkdir ./email_auth_cpp
WORKDIR /root/params/email_auth_cpp
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/email_auth --output ./email_auth
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/Makefile --output ./Makefile
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/calcwit.cpp --output ./calcwit.cpp
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/calcwit.hpp --output ./calcwit.hpp
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/calcwit.o --output ./calcwit.o
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/circom.hpp --output ./circom.hpp
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/email_auth.cpp --output ./email_auth.cpp
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/email_auth.dat --output ./email_auth.dat
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr.asm --output ./fr.asm
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr.cpp --output ./fr.cpp
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr.hpp --output ./fr.hpp
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr.o --output ./fr.o
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr_asm.o --output ./fr_asm.o
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/main.cpp --output ./main.cpp
RUN curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/main.o --output ./main.o
RUN chmod +x ./email_auth
WORKDIR /root
RUN ls params
RUN ls params/email_auth_cpp
RUN chmod +x circom_proofgen.sh
RUN mkdir build

RUN git clone https://github.com/Orbiter-Finance/rapidsnark.git rapidsnark
WORKDIR /root/rapidsnark
RUN yarn
RUN git submodule init
RUN git submodule update
RUN ./build_gmp.sh host
RUN mkdir build_prover
WORKDIR /root/rapidsnark/build_prover
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../package -DNVML_LIBRARY=/usr/local/cuda-12.4/targets/x86_64-linux/lib/stubs/libnvidia-ml.so
RUN make -j$(nproc) && make install
RUN chmod +x ../package/bin/prover_cuda
WORKDIR /root