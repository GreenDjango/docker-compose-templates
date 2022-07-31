##
#   Build Steps
##
FROM rust:latest as chef

# [Setup]
RUN cargo install cargo-chef
WORKDIR /app

# [Dependencies list]
FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

# [Builder]
FROM chef AS builder 
# Install deps
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
# Build application
COPY . .
RUN cargo build --release


##
#   Runtime Steps
##
FROM debian:buster-slim AS runtime

RUN apt-get update && apt-get install -y \ 
        libpq5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/target/release/appdev /usr/local/bin

ENTRYPOINT ["/usr/local/bin/appdev"]