FROM ghcr.io/mgoltzsche/podman:6.2.0-minimal AS podman


FROM ghcr.io/anomalyco/opencode:2.2.7

# Install tools
RUN apk add --update --no-cache shadow-uidmap nftables \
	git python3 py3-pip go rust gcc make musl-dev npm \
	bash curl jq yq github-cli

# Install chromium & puppeteer
RUN apk add --no-cache \
    udev \
    ttf-freefont \
    font-roboto \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
RUN npm install -g puppeteer@25.16.0 marked@18.1.3

# Install plugins
RUN npm install -g @upstash/context7-opencode@0.2.1

# Install podman
COPY --from=podman /usr/local /usr/local
COPY --from=podman /etc/containers /etc/containers
RUN ln -s /usr/local/bin/podman /usr/bin/docker

# Create opencode user
RUN set -ex; \
	adduser -D opencode -h /home/opencode -u 1000; \
	mkdir -p /home/opencode/.local/share/containers/storage; \
	chown -R opencode:opencode /home/opencode; \
	echo 'opencode:1:999' >> /etc/subuid; \
	echo 'opencode:1001:64535' >> /etc/subgid
USER opencode:opencode
ENV HOME=/home/opencode \
	PATH=/home/opencode/.local/bin:/home/opencode/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
	BUILDAH_ISOLATION=chroot container=oci
