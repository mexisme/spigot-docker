#!/usr/bin/env make -f

VERSION = 1.15.2
DIR=/opt/minecraft
PORT=25565
PORT_INSIDE=25565

PROJECT_SUFFIX=
PROJECT_NAME=minecraft_$(VERSION)$(PROJECT_SUFFIX)

DOCKER_COMPOSE_ARGS=--project-name "$(PROJECT_NAME)"

DATE_STAMP=$(shell date +%Y%m%h-%H%M%S)

.PHONY: default
default: run

.PHONY: all spigot build-tools multiverse worldedit
all: spigot multiverse worldedit

.PHONY: submodule-update
submodule-update:
	git submodule update --remote --init --recursive

.PHONY: init java spigot minecraft
java: init
spigot minecraft multiverse worldedit: java

init java multiverse worldedit:
	VERSION="$(VERSION)" docker-compose $(DOCKER_COMPOSE_ARGS) build "$@"

spigot minecraft:
	# VERSION="$(VERSION)" docker-compose $(DOCKER_COMPOSE_ARGS) build "$@"
	VERSION="$(VERSION)" DIR="$(DIR)" PORT="$(PORT)" PORT_INSIDE="$(PORT_INSIDE)" docker-compose $(DOCKER_COMPOSE_ARGS) up --remove-orphans "$@"

.PHONY: run
run:
	VERSION="$(VERSION)" docker-compose up spigot

.PHONY: backup
backup:
	sudo tar -C "$(DIR)" -cvf "$(BACKUP_DIR)/minecraft.$(DATE_STAMP).tar"
