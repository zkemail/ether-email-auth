FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Install Node.js, Yarn and required dependencies
RUN apt-get update \
  && apt-get install -y curl git gnupg build-essential cmake libgmp-dev libsodium-dev nasm curl m4 \
  && curl --silent --location https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y nodejs

RUN  git clone https://github.com/Orbiter-Finance/rapidsnark.git /rapidsnark
WORKDIR /rapidsnark
RUN git submodule init
RUN git submodule update
./build_gmp.sh host
mkdir build_prover && cd build_prover
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../package
make -j$(nproc) && make install

ENTRYPOINT ["/rapidsnark/package/build/prover_cuda"]
