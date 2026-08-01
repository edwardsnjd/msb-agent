# msb agent

This is an opinionated `msb` setup with a base image for the `pi` coding agent.

## Pre-requisites

Building the image:
- docker/podman

Running the image:
- [msb](https://docs.microsandbox.dev/)
- `~/.agents` configuration on host (symlinks supported)
- `$PWD` the project directory for the agent to work in

*Inference providers*

3 inference providers are supported via environment variables:

- OpenRouter via `OPENROUTER_API_KEY`
- InceptionLaps via `INCEPTION_API_KEY`
- Ollama via local host access

*Podman*

By default, the image is built and exported using `docker`.  If you want to use `podman` instead of `docker`:

```bash
export DOCKER=podman
# build or load
```

## Usage

**Prepare the base container image**

```bash
# Build base image
make build
# Load image into msb for use in sandboxes
make load
```

**Running a sandbox**

```bash
# Run a microvm for the current directory (auto removed)
scripts/msb-run
```

**Creating a sandbox**

Use `msb` as per [its docs](https://docs.microsandbox.dev/)

```bash
# Create a microvm for the current directory
scripts/msb-create

# Use it
scripts/msb-exec
scripts/msb-exec date
scripts/msb-exec pwd
# OR Use it manually
msb exec SANDBOX_ID -- pi
msb exec SANDBOX_ID -- bash

# Clean up all microvms for this directory
scripts/msb-list
scripts/msb-clean
# OR manually manage them selectively
msb stop ...
msb rm ...
```
