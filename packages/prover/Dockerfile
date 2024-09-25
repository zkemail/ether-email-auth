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
RUN git clone -b feat/gpu https://github.com/zkemail/ether-email-auth.git
WORKDIR /ether-email-auth/packages/prover
RUN pip install -r requirements.txt
RUN cp ./circom_proofgen.sh /root
RUN cp ./email_auth_with_body_parsing_with_qp_encoding /root
WORKDIR /root
RUN ls /root
RUN mkdir params
WORKDIR /root/params
RUN gdown "https://drive.google.com/uc?id=1XDPFIL5YK8JzLGoTjmHLXO9zMDjSQcJH"
RUN unzip params.zip
RUN mv params/* /root/params
WORKDIR /root
RUN ls params
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