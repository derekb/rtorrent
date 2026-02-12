# rtorrent

A minimal Docker image based on [jesec/rtorrent](https://github.com/jesec/rtorrent) with GNU utilities for lifecycle hook scripting.

## Features

- Uses the official static binary from `jesec/rtorrent`
- Includes bash, GNU coreutils, grep, sed, gawk for lifecycle hooks
- ~28 MB total (Alpine 3.21 + GNU utils + rtorrent binary)

## Quick Start

```bash
# Run with default configuration
podman run -d \
  -v rtorrent-data:/home/download/download \
  -v rtorrent-session:/home/download/.session \
  -p 6881-6999:6881-6999 \
  ghcr.io/derekb/rtorrent:latest

# Run with custom configuration (mount at $HOME/.rtorrent.rc)
podman run -d \
  -v ./my-rtorrent.rc:/home/download/.rtorrent.rc:ro \
  -v rtorrent-data:/home/download/download \
  -v rtorrent-session:/home/download/.session \
  ghcr.io/derekb/rtorrent:latest
```

## Configuration

rtorrent auto-discovers configuration files at:
- `$HOME/.rtorrent.rc` (default: `/home/download/.rtorrent.rc`)
- `$HOME/.config/rtorrent/rtorrent.rc`
- `/etc/rtorrent/rtorrent.rc`

Override `$HOME` via environment variable to change the config location.

See: [jesec/rtorrent](https://github.com/jesec/rtorrent)

## Upstream Project

This image is based on [jesec/rtorrent](https://github.com/jesec/rtorrent).

Please refer to the [upstream documentation](https://github.com/jesec/rtorrent) for rtorrent-specific configuration and features.

## License

This Dockerfile and associated scripts are provided as-is. rtorrent itself is licensed under GPLv2. See the [upstream project](https://github.com/jesec/rtorrent) for details.
