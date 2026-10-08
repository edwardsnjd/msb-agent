# msb agent

This is an opinionated `msb` setup with a base image for the `pi` and `opencode` coding agents.

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

*Utility scripts (Optional)*

The `scripts/` directory has some useful wrappers for the core `msb` commands to make it more ergonomic to work with sandboxes per directory.  Consider adding them to your `PATH`:

- `msb-run` - run a sandbox for the PWD and delete it afterwards
- `msb-create` - create a detached sandbox for the PWD
- `msb-list` - list all sandboxes for the PWD
- `msb-exec` - run a sandbox in the first sandbox in the PWD
- `msb-clean` - delete all sandboxes for the PWD

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
scripts/msb-exec bash
# OR Use it manually
msb exec SANDBOX_ID
msb exec SANDBOX_ID -- date
msb exec SANDBOX_ID -- pwd
msb exec SANDBOX_ID -- bash

# Clean up all microvms for this directory
scripts/msb-list
scripts/msb-clean
# OR Clean them up selectively
msb stop SANDBOX_ID
msb rm SANDBOX_ID
```

**Inference providers from inside sandbox**

The create/run scripts both ensure that environment variables for inference providers are set to dummy values inside the sandbox, and intercept and ammend any outgoing network requests to inference providers to use the correct values.

**Certificate authority inside the sandbox**

In order to proxy network requests the sandbox automatically provides a custom CA and overrides the CA chain inside the microvm (via the following environment variables) so applications accept the proxy CA:

```bash
$ env
...
CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
NODE_EXTRA_CA_CERTS=/.msb/tls/ca.pem
REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
...
```

**Certificate authority inside containers**

In order for containers inside the sandbox to accept the proxied traffic certificates, you need to propagate the relevant files and environment variables.

Example: `curl` inside container

```bash
podman run -ti --rm \
    --volume "$CURL_CA_BUNDLE":"$CURL_CA_BUNDLE" \
    --env CURL_CA_BUNDLE \
    ubuntu bash
```

Example: `node` inside container

```bash
podman run -ti --rm \
    --volume "$NODE_EXTRA_CA_CERTS":"$NODE_EXTRA_CA_CERTS" \
    --env NODE_EXTRA_CA_CERTS \
    node bash
```
