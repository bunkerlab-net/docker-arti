# Docker Arti

A Docker image of Arti: an implementation of Tor in Rust

![Docker Tag](https://img.shields.io/github/v/tag/bunkerlab-net/docker-arti?label=Latest%20Docker%20Tag) ![Arti Tag](https://img.shields.io/gitlab/v/tag/tpo%2Fcore%2Farti?gitlab_url=https%3A%2F%2Fgitlab.torproject.org&label=Latest%20Arti%20Tag)

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

## Tips

Don't tip me, please tip the [Tor Project](https://donate.torproject.org)
