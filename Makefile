DOCKER:= @docker
IMAGE=dns
REGISTRY=registry.gitlab.com/maissacrement
VERSION=1.1.0

login:
	${DOCKER} login registry.gitlab.com

version:
	@echo ${VERSION}

build:
	${DOCKER} build -t ${IMAGE}:${VERSION} .

pull:
	${DOCKER} pull ${REGISTRY}/${IMAGE}:latest

dev: build
	${DOCKER} run -it --rm \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=${DISPLAY} --entrypoint /bin/bash \
	${IMAGE}:${VERSION} 

tag:
	${DOCKER} tag ${IMAGE}:${VERSION} ${REGISTRY}/${IMAGE}:${VERSION}
	${DOCKER} tag ${IMAGE}:${VERSION} ${REGISTRY}/${IMAGE}:latest

push: login build tag
	${DOCKER} push ${REGISTRY}/${IMAGE}:${VERSION}
	${DOCKER} push ${REGISTRY}/${IMAGE}:latest

prod: 
	${DOCKER} pull ${REGISTRY}/${IMAGE}:latest
	${DOCKER} run -it --rm ${REGISTRY}/${IMAGE}:latest /bin/bash
