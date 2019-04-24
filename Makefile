VERSION = 1.13.2

.PHONY: all spigot build-tools multiverse worldedit
all: spigot multiverse worldedit

spigot: artefacts/spigot-$(VERSION).jar
artefacts/spigot-$(VERSION).jar:: src/spigot/spigot-$(VERSION).jar
	cp -iv $< $@

build-tools: artefacts/BuildTools.jar
artefacts/BuildTools.jar:: src/buildtools/target/BuildTools.jar
	cp -iv $< $@

multiverse: artefacts/multiverse-core.tar
artefacts/multiverse-core.tar:: src/Multiverse-Core/target
	tar -cv -C $< \
	    -f $@ *.jar

worldedit: artefacts/worldedit-dist.tar
artefacts/worldedit-dist.tar:: src/WorldEdit/target
	tar -cv -C $< \
	    -f $@ *.jar

##########
# Common:

src src/spigot:
	mkdir $@

##########
# Build tools:

src/buildtools: src
	git clone --depth 1 \
        https://hub.spigotmc.org/stash/scm/spigot/buildtools.git \
	  $@

src/buildtools/target/BuildTools.jar: src/buildtools
	cd $(@D)/..; \
	mvn -B -f ./pom.xml clean install

##########
# Spigot:

src/spigot: src

src/spigot/spigot-$(VERSION).jar: src/spigot artefacts/BuildTools.jar
	cd $<; \
	java -Xmx1024M -jar artefacts/BuildTools.jar

##########
# Add-ons:

src/Multiverse-Core: src
	git clone --depth 1 \
	  https://github.com/Multiverse/Multiverse-Core.git \
	  $@
	cd $@; git submodule update --init --recursive

src/Multiverse-Core/target: src/Multiverse-Core
	cd $@; \
	mvn clean install

src/WorldEdit: src
	git clone --depth 1 \
        https://github.com/sk89q/WorldEdit.git \
	  $@

src/WorldEdit/gradle.properties: src/WorldEdit
	echo 'org.gradle.jvmargs=-Xmx3G' >$@

src/WorldEdit/target: src/WorldEdit src/WorldEdit/gradle.properties
	./gradlew --info clean
	mvn clean install