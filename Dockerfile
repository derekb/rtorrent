# Stage 1: Source the static binary from upstream
FROM docker.io/jesec/rtorrent:0.9.8-r16 AS upstream

# Stage 2: Runtime
FROM alpine:3.21

RUN apk upgrade --no-cache && \
    apk add --no-cache \
        bash \
        ca-certificates \
        coreutils \
        curl \
        findutils \
        gawk \
        grep \
        ncurses-terminfo-base \
        sed \
        tini \
        tmux \
    && addgroup -g 1001 -S rtorrent \
    && adduser -u 1001 -S rtorrent -G rtorrent -h /home/download

COPY --from=upstream /usr/bin/rtorrent /usr/bin/rtorrent
COPY rootfs/ /

RUN apk add --no-cache --virtual .tic ncurses \
    && tic -x -o /usr/share/terminfo /tmp/ghostty.terminfo \
    && rm /tmp/ghostty.terminfo \
    && apk del --no-cache .tic \
    && chmod 1777 /tmp \
    && chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chown -R rtorrent:rtorrent /home/download /defaults

USER rtorrent:rtorrent
WORKDIR /home/download
ENV HOME=/home/download

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["rtorrent"]
