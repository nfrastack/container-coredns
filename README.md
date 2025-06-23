# github.com/tiredofit/coredns

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-coredns?style=flat-square)](https://github.com/tiredofit/docker-coredns/releases)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-coredns/build?style=flat-square)](https://github.com/tiredofit/docker-coredns/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/coredns.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/coredns/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/coredns.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/coredns/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)

## About

This will build a Docker Image for [CoreDNS](https://coredns.com), A DNS Server.


## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [Controller Options](#controller-options)
    - [UI Options](#ui-options)
    - [Client Options](#client-options)
    - [DNS Options](#dns-options)
      - [Optional](#optional)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/coredns).

```
docker pull tiredofit/coredns:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/coredns/pkgs/container/coredns)

```
docker pull ghcr.io/tiredofit/docker-coredns:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory  | Description          |
| ---------- | -------------------- |
| `/config/` | CoreDNS Config Files |
| `/data/`   | Volatile data        |
| `/logs/`   | Logfiles             |


* * *
### Environment Variables

#### Core Variables

| Variable                        | Description                                                    | Default                                  |
| ------------------------------- | -------------------------------------------------------------- | ---------------------------------------- |
| `CONFIG_PATH`                   | Path to CoreDNS config files                                   | `/config/`                               |
| `CONFIG_FILE`                   | CoreDNS config file name                                       | `coredns.conf`                           |
| `DATA_PATH`                     | Path to CoreDNS data files                                     | `/data/`                                 |
| `LOG_PATH`                      | Path to log files                                              | `/logs/`                                 |
| `LOG_FILE`                      | CoreDNS log file name                                          | `coredns.log`                            |
| `LISTEN_IP`                     | IP address to bind CoreDNS                                     | `0.0.0.0`                                |
| `LISTEN_PORT`                   | Port to bind CoreDNS                                           | `53`                                     |
| `CONFIG_INCLUDE`                | Path to custom config include file                             | `/config/config.include`                 |

#### Per-Domain Variables (for multiple domains)

Set these for each domain, incrementing the XX index (e.g., 01, 02, 03...):

| Variable                                 | Description                                                      | Example                                 |
| ----------------------------------------- | ---------------------------------------------------------------- | --------------------------------------- |
| `DOMAIN_XX_NAME`                         | Domain name                                                      | `example.com`                           |
| `DOMAIN_XX_ROLE`                         | `primary` or `secondary`                                         | `primary`                               |
| `DOMAIN_XX_ZONE_FILE`                    | Path to zone file (primary only)                                 | `/data/example_com.zone`                |
| `DOMAIN_XX_HOSTS_FILE`                   | Path to hosts file (optional, primary only)                      | `/data/example_com.hosts`               |
| `DOMAIN_XX_TRANSFER_TO`                  | Space-separated list of IPs allowed AXFR (primary only)          | `10.0.0.2 *`                            |
| `DOMAIN_XX_TRANSFER_FROM`                | Space-separated list of IP:PORT to AXFR from (secondary only)    | `10.0.0.1:53`                           |
| `DOMAIN_XX_LISTEN_PORT`                  | Listen port for this domain (overrides global)                   | `1053`                                  |
| `DOMAIN_XX_ENABLE_FORWARD`               | Enable forwarding for this domain (`true`/`false`)               | `true`                                  |
| `DOMAIN_XX_FORWARD_MODE`                 | Forward mode: `system` or `upstream`                            | `system`                                |
| `DOMAIN_XX_FORWARD_UPSTREAM_HOST`        | Upstream DNS hosts (space-separated)                             | `dns://1.1.1.1:53 dns://1.0.0.1:53`     |
| `DOMAIN_XX_RELOAD`                       | Enable reload plugin (`true`/`false`)                            | `true`                                  |
| `DOMAIN_XX_CACHE`                        | Cache TTL in seconds                                             | `30`                                    |
| `DOMAIN_XX_ERRORS`                       | Enable errors plugin (`true`/`false`)                            | `true`                                  |
| `DOMAIN_XX_LOOP`                         | Enable loop plugin (`true`/`false`)                              | `true`                                  |

#### Global/Default Variables

| Variable                        | Description                                                    | Default                                  |
| ------------------------------- | -------------------------------------------------------------- | ---------------------------------------- |
| `DEFAULT_ENABLE_FORWARD`        | Default for per-domain forwarding                              | `true`                                   |
| `DEFAULT_FORWARD_MODE`          | Default forward mode                                           | `system`                                 |
| `DEFAULT_FORWARD_UPSTREAM_HOST` | Default upstream DNS hosts                                     | `dns://1.1.1.1:53 dns://1.0.0.1:53`      |
| `DEFAULT_RELOAD`                | Default reload plugin                                          | `true`                                   |
| `DEFAULT_CACHE`                 | Default cache TTL                                              | `30`                                     |
| `DEFAULT_ERRORS`                | Default errors plugin                                          | `true`                                   |
| `DEFAULT_LOOP`                  | Default loop plugin                                            | `true`                                   |

#### Example: Multiple Domains

```yaml
services:
  coredns-app:
    image: tiredofit/coredns
    environment:
      - DOMAIN_01_NAME=example.com
      - DOMAIN_01_ROLE=primary
      - DOMAIN_01_ZONE_FILE=/data/example_com.zone
      - DOMAIN_01_TRANSFER_TO=*
      - DOMAIN_01_ENABLE_FORWARD=true
      - DOMAIN_01_FORWARD_MODE=system
      - DOMAIN_01_CACHE=60

      - DOMAIN_02_NAME=internal.lan
      - DOMAIN_02_ROLE=secondary
      - DOMAIN_02_TRANSFER_FROM=10.0.0.1:53
      - DOMAIN_02_ENABLE_FORWARD=false
      - DOMAIN_02_LISTEN_PORT=1053

      - DEFAULT_ENABLE_FORWARD=true
      - DEFAULT_FORWARD_MODE=system
      - DEFAULT_FORWARD_UPSTREAM_HOST=dns://1.1.1.1:53 dns://1.0.0.1:53
      - DEFAULT_CACHE=30
      - DEFAULT_ERRORS=true
      - DEFAULT_LOOP=true
```

This will configure two domains, one as a primary and one as a secondary, each with their own settings. You can add as many `DOMAIN_XX_*` blocks as needed for additional domains.

### Networking

| Port | Protocol | Description |
| ---- | -------- | ----------- |
| `53` | `udp`    | CoreDNS     |


## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- [Sponsor me](https://tiredofit.ca/sponsor) for personalized support.

### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- [Sponsor me](https://tiredofit.ca/sponsor) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- [Sponsor me](https://tiredofit.ca/sponsor) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* <https://coredns.io>
