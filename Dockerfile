ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.21

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG COREDNS_VERSION

ENV COREDNS_VERSION=${COREDNS_VERSION:-"v1.12.3"} \
    COREDNS_REPO_URL=https://github.com/coredns/coredns \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/coredns" \
    IMAGE_REPO_URL="https://github.com/tiredofit/coredns/"

RUN source assets/functions/00-container && \
    set -x && \
    addgroup -S -g 9376 coredns && \
    adduser -D -S -s /sbin/nologin \
            -h /dev/null \
            -G coredns \
            -g "coredns" \
            -u 9376 coredns \
            && \
    \
    package update && \
    package upgrade && \
    package install .coredns-build-deps \
                    build-base \
                    go \
                    git \
                    #unbound-dev \
                    && \
    package install .coredns-run-deps \
                    moreutils \
                    #unbound-libs \
                    util-linux-misc \
                    iptables \
                    libc6-compat \
                    libstdc++ \
                    && \
    \
    clone_git_repo "${COREDNS_REPO_URL}" "${COREDNS_VERSION}" && \
    make && \
    mv coredns /usr/local/bin && \
    package remove \
                    .coredns-build-deps \
                    && \
    package cleanup && \
    \
    rm -rf \
            /root/.cache \
            /root/.gitconfig \
            /root/.npm \
            /root/go \
            /usr/src/*

EXPOSE 53
EXPOSE 53/udp

COPY install /
