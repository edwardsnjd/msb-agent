# msb agent

## Pre-requisites

- docker/podman
- [msb](https://docs.microsandbox.dev/)

*Podman*

By default, the image is built and exported using `docker`.  If you want to use `podman` instead of `docker`:

`export DOCKER=podman`

## Usage

**Prepare the base container image**

```bash
# Build base image
scripts/build
# Load image into msb
scripts/load
# Create an existing microvm for the current directory
scripts/create
```

**Creating a sandbox**

Use `msb` as per [its docs](https://docs.microsandbox.dev/)

```bash
msb exec PROJ_NAME -- pi
msb exec PROJ_NAME -- bash
```
