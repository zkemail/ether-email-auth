# Stage 1: Build Stage
# Use the official Rust image to build the project
FROM rust:latest AS builder

# Use bash as the shell
SHELL ["/bin/bash", "-c"]

# Install NVM, Node.js, and Yarn
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
    && . $HOME/.nvm/nvm.sh \
    && nvm install 18 \
    && nvm alias default 18 \
    && nvm use default \
    && npm install -g yarn

# Set the working directory
WORKDIR /relayer

# Configure Git to avoid common issues and increase clone verbosity
RUN git config --global advice.detachedHead false \
    && git config --global core.compression 0 \
    && git config --global protocol.version 2 \
    && git config --global http.postBuffer 1048576000 \
    && git config --global fetch.verbose true

# Copy the project files to the build stage
COPY . .

# Install Yarn dependencies with a retry mechanism
RUN . $HOME/.nvm/nvm.sh && nvm use default && yarn || \
    (sleep 5 && yarn) || \
    (sleep 10 && yarn)

# Install Foundry and add forge to PATH
RUN curl -L https://foundry.paradigm.xyz | bash \
    && . $HOME/.bashrc \
    && foundryup \
    && ln -s $HOME/.foundry/bin/forge /usr/local/bin/forge \
    && forge --version

# Build the contracts
WORKDIR /relayer/packages/contracts
RUN source $HOME/.nvm/nvm.sh && nvm use default && yarn && forge build

# Set the working directory for the Rust project and build it
WORKDIR /relayer/packages/relayer

# Copy the IC PEM file
COPY packages/relayer/.ic.pem /relayer/.ic.pem

# Build the Rust project with caching
RUN cargo build --release

# Stage 2: Final Stage with Minimal Image
# Use a slim Debian image to keep the final image small
FROM debian:bookworm-slim

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the built binary from the builder stage
COPY --from=builder /relayer/target/release/relayer /usr/local/bin/relayer

# Copy the IC PEM file
COPY --from=builder /relayer/.ic.pem /relayer/.ic.pem

# Expose the required port
EXPOSE 4500

# Set the default command to run the application
CMD ["/usr/local/bin/relayer"]
