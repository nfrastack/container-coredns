# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG BASE_IMAGE
ARG DISTRO
ARG DISTRO_VARIANT

FROM ${BASE_IMAGE}:${DISTRO}_${DISTRO_VARIANT}

LABEL \
        org.opencontainers.image.title="CoreDNS" \
        org.opencontainers.image.description="DNS Server" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/coredns" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-coredns/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-coredns.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ARG \
    COREDNS_REPO_URL \
    COREDNS_VERSION

ENV COREDNS_VERSION=${COREDNS_VERSION:-"v1.12.4"} \
    COREDNS_REPO_URL=${COREDNS_REPO_URL:-"https://github.com/coredns/coredns"} \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="nfrastack/coredns" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-coredns/"

RUN echo "" && \
    COREDNS_BUILD_DEPS_ALPINE=" \
                                build-base \
                                go \
                                git \
                            " \
                        && \
    COREDNS_RUN_DEPS_ALPINE=" \
                                iptables \
                                libc6-compat \
                                libstdc++ \
                                moreutils \
                                util-linux-misc \
                            " \
                        && \
    \
    source /container/base/functions/container/build && \
    container_build_log && \
    create_user coredns 9376 coredns 9376 && \
    package update && \
    package upgrade && \
    package install \
                        COREDNS_BUILD_DEPS \
                        COREDNS_RUN_DEPS \
                        && \
    \
    clone_git_repo "${COREDNS_REPO_URL}" "${COREDNS_VERSION}" && \
    make && \
    mv coredns /usr/local/bin && \
    package remove \
                    COREDNS_BUILD_DEPS \
                    && \
    package cleanup

EXPOSE 53
EXPOSE 53/udp

COPY rootfs /
