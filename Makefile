IMAGE ?= docker.io/mgoltzsche/opencode
DOCKER ?= $(if $(shell podman -v),podman,docker)

container:
	$(DOCKER) build --rm -t $(IMAGE) .
