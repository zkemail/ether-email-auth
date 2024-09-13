# Use the base image
FROM us-central1-docker.pkg.dev/zkairdrop/ether-email-auth/relayer-base:v1

# Copy the project files
COPY packages/relayer /relayer/packages/relayer

# Set the working directory for the Rust project
WORKDIR /relayer/packages/relayer

# Build the Rust project with caching
RUN cargo build

# Expose port
EXPOSE 4500

# Set the default command
CMD ["cargo", "run"]
