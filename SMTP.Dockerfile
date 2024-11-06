# Use the official Rust image as the base image for building
FROM rust:1.73 AS builder

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /usr/src/relayer-smtp

# Clone the repository
RUN git clone https://github.com/zkemail/relayer-smtp.git .

# Build the application
RUN cargo build --release

# Use a minimal base image for the final stage
FROM debian:bookworm-slim

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the built binary from the builder stage
COPY --from=builder /usr/src/relayer-smtp/target/release/relayer-smtp /usr/local/bin/relayer-smtp

# Expose the port the app runs on
EXPOSE 8080

# Set the default command to run the application
CMD ["/usr/local/bin/relayer-smtp"]