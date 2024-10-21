# Use the base image
FROM bisht13/relayer-base

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
