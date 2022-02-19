# Copyright: (c) 2022, Justin Béra (@just1not2) <me@just1not2.org>
# Apache License 2.0 (see LICENSE or https://www.apache.org/licenses/LICENSE-2.0.txt)

VERSION=1.10.4

default: install

build:
	docker build -t just1not2/streama:test .

install:
	docker-compose up -d

release: build
	docker tag just1not2/streama:test just1not2/streama:latest
	docker tag just1not2/streama:test just1not2/streama:${shell echo ${VERSION} | cut -d '.' -f -2}
	docker tag just1not2/streama:test just1not2/streama:${VERSION}
	docker push just1not2/streama:latest
	docker push just1not2/streama:${shell echo ${VERSION} | cut -d '.' -f -2}
	docker push just1not2/streama:${VERSION}
