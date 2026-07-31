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
    aardvark-dns \
    iproute2 \
    fd-find \
    ripgrep \
    bat \
  && rm -rf /var/lib/apt/lists/*

RUN npm install --global npm

RUN npm install --global --ignore-scripts @earendil-works/pi-coding-agent

# Configure inference providers
COPY models.json /root/.pi/agent/models.json

# Configure podman volumes and network
COPY storage.conf /etc/containers/storage.conf
COPY containers.conf /etc/containers/containers.conf

ENTRYPOINT ["pi"]
