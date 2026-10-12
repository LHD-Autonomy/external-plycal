IMAGE_NAME = plycal:18.04
CONTAINER_NAME = plycal_container

.PHONY: build run

SHELL := /bin/bash
.SHELLFLAGS := -e -c

build:
	docker build -t $(IMAGE_NAME) .

run:
	@set -e; \
	if [ -z "$$DISPLAY" ]; then \
		echo "Error: DISPLAY is not set. Run this target from your graphical session."; \
		exit 1; \
	fi; \
	if ! command -v xauth >/dev/null 2>&1; then \
		echo "Error: xauth is not installed on the host. Install it with: sudo apt install xauth"; \
		exit 1; \
	fi; \
	XAUTH_FILE=$$(mktemp); \
	trap 'rm -f "$$XAUTH_FILE"' EXIT; \
	xauth extract "$$XAUTH_FILE" "$$DISPLAY"; \
	if [ ! -s "$$XAUTH_FILE" ]; then \
		echo "Error: No X11 authorization cookie found for DISPLAY=$$DISPLAY"; \
		echo "Check your host XAUTHORITY and xauth list output."; \
		exit 1; \
	fi; \
	chmod 644 "$$XAUTH_FILE"; \
	docker run --rm -it \
		--name $(CONTAINER_NAME) \
		-e DISPLAY="$$DISPLAY" \
		-e XAUTHORITY=/tmp/.docker.xauth \
		--device /dev/dri \
		-v "$$XAUTH_FILE:/tmp/.docker.xauth:ro" \
		-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
		-v "$(shell pwd):/workspace" \
		$(IMAGE_NAME) bash