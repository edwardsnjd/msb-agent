# msb agent

This is an opinionated `msb` setup with a base image for the `pi` coding agent.

## Pre-requisites

- docker/podman
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

`export DOCKER=podman`

## Usage

**Prepare the base container image**

```bash
# Build base image
scripts/build
# Load image into msb
scripts/load
# Run a microvm for the current directory (auto removed)
scripts/run
```

**Creating a sandbox**

Use `msb` as per [its docs](https://docs.microsandbox.dev/)

```bash
# Create a microvm for the current directory
scripts/create
# Use it
msb exec PROJ_NAME -- pi
msb exec PROJ_NAME -- bash
# Manually clean up when finished
msb ls
msb stop ...
msb rm ...
```
