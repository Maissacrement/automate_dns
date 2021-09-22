DOCKER:= @docker
IMAGE=dns
REGISTRY=registry.gitlab.com/maissacrement
VERSION=1.0.0

login:
	${DOCKER} login registry.gitlab.com

version:
	@echo ${VERSION}

build:
	${DOCKER} build -t ${IMAGE}:${VERSION} .

dev: build
	${DOCKER} run -it --rm \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=${DISPLAY} \
	${IMAGE}:${VERSION}

tag:
	${DOCKER} tag ${IMAGE}:${VERSION} ${REGISTRY}/${IMAGE}:${VERSION}
	${DOCKER} tag ${IMAGE}:${VERSION} ${REGISTRY}/${IMAGE}:latest

push: login build
	${DOCKER} push ${REGISTRY}/${IMAGE}:${VERSION}
	${DOCKER} push ${REGISTRY}/${IMAGE}:latest

prod: 
	${DOCKER} pull ${REGISTRY}/${IMAGE}:latest
	${DOCKER} run -it --rm ${REGISTRY}/${IMAGE}:latest /bin/bash