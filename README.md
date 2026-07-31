# msb agent

## Pre-requisites

- docker/podman
- [msb](https://docs.microsandbox.dev/)

## Usage

- Load image into `msb`:
    - `scripts/build-and-load`
    - `DOCKER=podman scripts/build-and-load` (using podman instead of docker)
- Create an existing microvm for the current directory:
    - `scripts/create`
- Use it:
    - `msb exec PROJ_NAME -- pi`
    - `msb exec PROJ_NAME -- bash`
