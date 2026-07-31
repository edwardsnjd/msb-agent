# msb agent

## Pre-requisites

- docker/podman
- msb

## Usage

- Load image into `msb`:
    - `scripts/build-and-load`
    - `DOCKER=podman scripts/build-and-load` (using podman instead of docker)
- Create an existing microvm:
    - `msb create --name {PROJ}
