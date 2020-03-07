#!/usr/bin/env make -f

VERSION = 1.15.2

.PHONY: all spigot build-tools multiverse worldedit
all: spigot multiverse worldedit

.PHONY: submodule-update
submodule-update:
	git submodule update --remote --init --recursive

.PHONY: init java spigot
java: init
spigot: java
init java spigot:
	VERSION="$(VERSION)" docker-compose build "$@"

run:
	VERSION="$(VERSION)" docker-compose up spigot
