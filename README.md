# Squid Container Image
Container image for the [Squid caching proxy](http://www.squid-cache.org/) based on [Alpine Linux](https://alpinelinux.org/).

# Documentation
## Getting the Image
The container image is published on [Dockerhub](https://hub.docker.com/repository/docker/mpreu/squid) and can be accessed with e.g.:

```bash
podman pull docker.io/mpreu/squid:4.13
```

Alternatively, the image is also available in the [Github Container Registry](https://docs.github.com/en/packages/guides/about-github-container-registry):

```bash
podman pull ghcr.io/mpreu/squid:4.13
```

## Configuration
To provide a `squid.conf` configuration file the mount point `/etc/squid/squid.conf` can be used:

```bash
podman run \
  --name squid \
  --volume /path/to/squid.conf:/etc/squid/squid.conf \
  docker.io/mpreu/squid:4.13
```

### Command-line Parameters
For further customization additional command-line parameters are forwarded to Squid. For example, getting the current installed Squid version in the container can be displayed with:

```bash
podman run docker.io/mpreu/squid:4.13 --version
```

## Persistent Cache and Logs
To allow persistent caches and logs during container shutdowns/restarts/... the following directories can be mapped to the host:

- `/var/spool/squid` for caches
- `/var/log/squid` for logs

```bash
podman run \
  --name squid \
  --volume /tmp/squid/cache:/var/spool/squid \
  --volume /tmp/squid/log:/var/log/squid \
  docker.io/mpreu/squid:4.13
```

In case persistent logs are not required, they can just be accessed with e.g.:

```bash
podman exec -it squid tail -f /var/log/squid/access.log
```

## Running as a Service
When running `Squid` in a container, one usual use-case is to have it running as a service. This can be achieved on a `systemd` system using the following example unit deployed to e.g. `'/etc/systemd/system/squid.service'`:

```bash
[Unit]
Description=Squid container service
After=network-online.target

[Service]
Restart=always
ExecStartPre=-/usr/bin/podman stop %n
ExecStartPre=-/usr/bin/podman rm %n
ExecStart=/usr/bin/podman run --rm \
                              --name %n \
                              --security-opt label=disable \
                              -p 3128:3128 \
                              -v /path/to/squid.conf:/etc/squid/squid.conf \
                              docker.io/mpreu/squid:4.13

[Install]
WantedBy=default.target
```

The Squid container service can then be started and enabled with:

```bash
systemctl enable --now squid
```
