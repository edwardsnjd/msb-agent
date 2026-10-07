FROM node:26-slim

# Install utilities:
# - dev tools (git, vim, tree, less, curl)
# - podman (and podman-compose, aardvark-dns, iproute2)
# - utilities (fd-find, ripgrep, bat)
RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    git \
    vim \
    tree \
    less \
    curl \
    podman \
    podman-compose \
    fuse-overlayfs \
    aardvark-dns \
    iproute2 \
    fd-find \
    ripgrep \
    bat \
  && rm -rf /var/lib/apt/lists/*

RUN npm install --global npm

RUN npm install --global --ignore-scripts @earendil-works/pi-coding-agent

RUN npm install --global --allow-scripts=@opencode/cli @opencode/cli

# Configure inference providers
COPY pi/models.json /root/.pi/agent/models.json

# Configure podman volumes and network
COPY podman/storage.conf /etc/containers/storage.conf
COPY podman/containers.conf /etc/containers/containers.conf

ENTRYPOINT ["bash"]
