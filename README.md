# Docker Arti

A Docker image of Arti: an implementation of Tor in Rust

## Usage

```bash
docker run -d \
  --name=arti \
  --restart=unless-stopped \
  -p 9150:9150 \
  ghcr.io/bunkerlab-net/arti \
    proxy
```

### Verify it's working

```bash
curl \
  --socks5 localhost:9150 \
  --socks5-hostname localhost:9150 \
  https://check.torproject.org/api/ip
```

### Tips

Don't tip me, please tip the [Tor Project](https://donate.torproject.org)
