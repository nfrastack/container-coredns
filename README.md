# nfrastack/container-coredns

## About

This repository will build a container with [CoreDNS](https://coredns.io), a DNS Server.

* Auto Configuration Support

## Maintainer

- [Nfrastack](https://www.nfrastack.com)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi-Architecture Support](#multi-architecture-support)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Core Configuration](#core-configuration)
    - [Per-Domain Configuration (for multiple domains)](#per-domain-configuration-for-multiple-domains)
    - [Global/Default Variables](#globaldefault-variables)
    - [Example: Multiple Domains](#example-multiple-domains)
- [Users and Groups](#users-and-groups)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support \& Maintenance](#support--maintenance)
- [References](#references)
- [License](#license)

## Installation

### Prebuilt Images
Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-coredns/pkgs/container/container-coredns) and [Docker Hub](https://hub.docker.com/r/nfrastack/coredns).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-coredns:(image_tag)
docker.io/nfrastack/coredns:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>-<optional_distribution>_<optional_distribution_variant>`

Example:

`ghcr.io/nfrastack/container-coredns:latest` or

`ghcr.io/nfrastack/container-coredns:1.0` or

* `latest` will be the most recent commit
* An otpional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest
* If it is built for multiple distributions there may exist a value of `alpine` or `debian`
* If there are multiple distribution variations it may include a version - see the registry for availability

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description         |
| --------- | ------------------- |
| `/config` | Configuration Files |
| `/data`   | Volatile Data       |
| `/logs`   | Log Files           |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description |
| ------------------------------------------------------- | ----------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image  |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

| Variable         | Description                        | Default                  |
| ---------------- | ---------------------------------- | ------------------------ |
| `CONFIG_PATH`    | Path to CoreDNS config files       | `/config/`               |
| `CONFIG_FILE`    | CoreDNS config file name           | `coredns.conf`           |
| `CONFIG_INCLUDE` | Path to custom config include file | `/config/config.include` |
| `DATA_PATH`      | Path to CoreDNS data files         | `/data/`                 |
| `LOG_PATH`       | Path to log files                  | `/logs/`                 |
| `LOG_FILE`       | CoreDNS log file name              | `coredns.log`            |
| `LISTEN_IP`      | IP address to bind CoreDNS         | `0.0.0.0`                |
| `LISTEN_PORT`    | Port to bind CoreDNS               | `53`                     |

#### Per-Domain Configuration (for multiple domains)

Set these for each domain, incrementing the XX index (e.g., 01, 02, 03...):

| Variable                          | Description                                                   | Example                             | Advanced |
| --------------------------------- | ------------------------------------------------------------- | ----------------------------------- | -------- |
| `DOMAIN_XX_NAME`                  | Domain name                                                   | `example.com`                       |          |
| `DOMAIN_XX_ROLE`                  | `primary` or `secondary`                                      | `primary`                           |          |
| `DOMAIN_XX_ZONE_FILE`             | Path to zone file (primary only)                              | `/data/example_com.zone`            |          |
| `DOMAIN_XX_HOSTS_FILE`            | Path to hosts file (optional, primary only)                   | `/data/example_com.hosts`           |          |
| `DOMAIN_XX_TRANSFER_TO`           | Space-separated list of IPs allowed AXFR (primary only)       | `10.0.0.2 *`                        |          |
| `DOMAIN_XX_TRANSFER_FROM`         | Space-separated list of IP:PORT to AXFR from (secondary only) | `10.0.0.1:53`                       |          |
| `DOMAIN_XX_LISTEN_PORT`           | Listen port for this domain (overrides global)                | `1053`                              |          |
| `DOMAIN_XX_ENABLE_FORWARD`        | Enable forwarding for this domain (`true`/`false`)            | `true`                              |          |
| `DOMAIN_XX_FORWARD_MODE`          | Forward mode: `system` or `upstream`                          | `system`                            |          |
| `DOMAIN_XX_FORWARD_UPSTREAM_HOST` | Upstream DNS hosts (space-separated)                          | `dns://1.1.1.1:53 dns://1.0.0.1:53` |          |
| `DOMAIN_XX_RELOAD`                | Enable reload plugin (`true`/`false`)                         | `true`                              |          |
| `DOMAIN_XX_CACHE`                 | Cache TTL in seconds                                          | `30`                                |          |
| `DOMAIN_XX_ERRORS`                | Enable errors plugin (`true`/`false`)                         | `true`                              |          |
| `DOMAIN_XX_LOG_QUERIES`           | Enable logging of querites (`true` / `false`)                 | `true`                              |          |
| `DOMAIN_XX_LOOP`                  | Enable loop plugin (`true`/`false`)                           | `true`                              |          |

#### Global/Default Variables

| Variable                        | Description                       | Default                             | Advanced |
| ------------------------------- | --------------------------------- | ----------------------------------- | -------- |
| `DEFAULT_ENABLE_FORWARD`        | Default for per-domain forwarding | `true`                              |          |
| `DEFAULT_FORWARD_MODE`          | Default forward mode              | `system`                            |          |
| `DEFAULT_FORWARD_UPSTREAM_HOST` | Default upstream DNS hosts        | `dns://1.1.1.1:53 dns://1.0.0.1:53` |          |
| `DEFAULT_RELOAD`                | Default reload plugin             | `true`                              |          |
| `DEFAULT_CACHE`                 | Default cache TTL                 | `30`                                |          |
| `DEFAULT_ERRORS`                | Default errors plugin             | `true`                              |          |
| `DEFAULT_LOOP`                  | Default loop plugin               | `true`                              |          |
| `DEFAULT_LOG_QUERIES`           | Default logging of queries        | `true`                              |          |

#### Example: Multiple Domains

```yaml
services:
  coredns-app:
    image: docker.io/nfrastack/coredns
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
      - DEFAULT_LOG_QUERIES=true
      - DEFAULT_LOOP=true

```

This will configure two domains, one as a primary and one as a secondary, each with their own settings. You can add as many `DOMAIN_XX_*` blocks as needed for additional domains.

## Users and Groups

| Type  | Name      | ID   |
| ----- | --------- | ---- |
| User  | `coredns` | 9376 |
| Group | `coredns` | 9376 |

### Networking

| Port | Protocol | Description      |
| ---- | -------- | ---------------- |
| `53` | tcp      | CoreDNS Resolver |
| `53` | udp      | CoreDNS Resolver |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

## Support & Maintenance

- For community help, tips, and community discussions, visit the [Discussions board](/discussions).
- For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
- To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
- Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
- Updates are best-effort, with priority given to active production use and support agreements.

## References

* <https://coredns.io>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
