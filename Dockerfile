###################
# --- builder --- #
###################
FROM docker.io/rust:1.84 AS builder

WORKDIR /opt
ARG VERSION=arti-v1.3.2
RUN git clone https://gitlab.torproject.org/tpo/core/arti.git -b $VERSION --depth 1
WORKDIR /opt/arti
RUN cargo build --locked --release --package arti

##################
# --- runner --- #
##################
FROM docker.io/debian:12-slim

RUN apt-get update && \
    apt-get install -y curl sqlite3 && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup --gid 65532 arti && \
    adduser --system --uid 65532 --gid 65532 --home /var/lib/tor arti

COPY --from=builder /opt/arti/target/release/arti /usr/local/bin/arti

USER 65532
WORKDIR /var/lib/tor
COPY --chown=65532:65532 ./arti.toml /var/lib/tor/.config/arti/arti.toml

# Tor Proxy
EXPOSE 9150

HEALTHCHECK --interval=10s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --socks5 localhost:9150 \
      --socks5-hostname localhost:9150 \
      -s \
      -f \
      https://check.torproject.org/api/ip | grep -q '"IsTor":true' || exit 1

ENTRYPOINT [ "/usr/local/bin/arti" ]
CMD [ "help" ]
