VERSION ?= latest
IMAGE ?= ghcr.io/mgoltzsche/opencode

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: container
container: ## Build the container.
	docker build --rm -t $(IMAGE):$(VERSION) .

.PHONY: binfmt-config
binfmt-config: ## Enable multi-arch support on the host.
	docker run --rm --privileged multiarch/qemu-user-static:7.2.0-1 --reset -p yes

.PHONY: release
release: PLATFORMS ?= linux/amd64,linux/arm64
release: ## Build and push a multi-arch container image, requires qemu/binfmt.
	docker buildx build --platform $(PLATFORMS) --output type=registry -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .
