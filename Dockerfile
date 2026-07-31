FROM node:26-slim

RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    git \
    vim \
    tree \
    less \
    curl \
    fd-find \
    ripgrep \
    bat \
  && rm -rf /var/lib/apt/lists/*

RUN npm install --global npm

RUN npm install --global --ignore-scripts @earendil-works/pi-coding-agent

COPY models.json /root/.pi/agent/models.json

ENTRYPOINT ["/bin/sh"]
