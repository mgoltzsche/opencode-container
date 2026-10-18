#!/bin/sh

OPTS=
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"
if [ -f "$OPENCODE_CONFIG" ]; then
	OPTS="--mount type=bind,src=$OPENCODE_CONFIG,dst=/opencode.json -e OPENCODE_CONFIG=/opencode.json"
fi

# NOTE: the nested container storage must not live on the container's
# fuse-overlayfs rootfs: fuse-overlayfs cannot be stacked on fuse-overlayfs
# (opaque xattrs are rejected -> mkdir EPERM), so use a tmpfs instead.
podman run -it --rm --device /dev/fuse --network=host --userns=keep-id \
	--tmpfs /home/opencode/.local/share/containers/storage:mode=1777 \
	$OPTS \
	-v "`pwd`:/workspace" -w /workspace \
	docker.io/mgoltzsche/opencode "$@"
