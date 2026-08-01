# Makefile for msb-agent

DOCKER ?= docker

.PHONY: build
build:
	$(DOCKER) build --tag "localhost/msb-agent:latest" .

.PHONY: load
load:
	$(DOCKER) save "localhost/msb-agent:latest" | msb load
