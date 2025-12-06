###################
# --- builder --- #
###################
FROM docker.io/rust:1.91-alpine@sha256:8efbfb788786eeb127adc581394349c5fb567712156e0f8c2e499acadbc23756 AS builder

RUN apk add --update git \
    musl-dev \
    pkgconfig \
    openssl-dev \
    perl \
    make

WORKDIR /opt
ARG VERSION=arti-v1.7.0
RUN git clone https://gitlab.torproject.org/tpo/core/arti.git -b $VERSION --depth 1
WORKDIR /opt/arti
RUN cargo build --locked --release --package arti --features static

##################
# --- runner --- #
##################
FROM docker.io/alpine:3@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375 AS arti

RUN apk add --update --no-cache curl && \
    addgroup -g 65532 arti && \
    adduser --system --uid 65532 -G arti --home /var/lib/tor -s /bin/sh arti

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
