#!/usr/bin/env make -f

#VERSION = 1.15.2
#VERSION = 1.16.4
VERSION = 1.16.5
#VERSION = 1.17

PORT=25565
PORT_INSIDE=25565

PROJECT_SUFFIX=
PROJECT_NAME=minecraft_$(VERSION)$(PROJECT_SUFFIX)

DOCKER_COMPOSE_ARGS=--project-name "$(PROJECT_NAME)"

BACKUP_DIR=$(PWD)/BACKUP
DATE_STAMP=$(shell date +%Y%m%d-%H%M%S)

.PHONY: default
default: run

.PHONY: build spigot build-tools
build: spigot

.PHONY: buildm-all spigot build-tools
build-all: build multiverse worldedit

.PHONY: submodule-update
submodule-update:
	git submodule update --remote --init --recursive

.PHONY: init java spigot minecraft
java: init
spigot minecraft multiverse worldedit: java

init java multiverse worldedit:
	VERSION="$(VERSION)" docker-compose $(DOCKER_COMPOSE_ARGS) build "$@"

.PHONY: harry-potter furniture robertson

harry-potter-1.13.2: VERSION=1.13.2
harry-potter-1.13.2: DIR=/opt/minecraft-harry_1.13.2
harry-potter-1.13.2: PORT=25566
harry-potter-1.13.2: minecraft

harry-potter: VERSION=1.16.3
harry-potter: DIR=/opt/minecraft-harry
harry-potter: PORT=25566
harry-potter: minecraft

furniture: VERSION=1.16.1
furniture: DIR=/opt/minecraft-furniture
furniture: PORT=25567
furniture: minecraft

robertson: DIR=/opt/minecraft
robertson: spigot

spigot minecraft:
	$(if $(DIR),,$(error $$DIR is not provided?))
	$(if $(VERSION),,$(error $$VERSION is not provided?))
	$(if $(PORT),,$(error $$PORT is not provided?))
	$(if $(PORT_INSIDE),,$(error $$PORT_INSIDE is not provided?))
	# VERSION="$(VERSION)" docker-compose $(DOCKER_COMPOSE_ARGS) build "$@"
	VERSION="$(VERSION)" DIR="$(DIR)" PORT="$(PORT)" PORT_INSIDE="$(PORT_INSIDE)" docker-compose $(DOCKER_COMPOSE_ARGS) up --remove-orphans "$@"

.PHONY: run
run:
	VERSION="$(VERSION)" docker-compose up spigot

.PHONY: backup
backup: END-DIR=$(notdir $(DIR))
backup:
	$(if $(DIR),,$(error $$DIR is not provided?))
	sudo tar -C "$(DIR)" -cvf "$(BACKUP_DIR)/$(END-DIR).$(DATE_STAMP).tar" .
