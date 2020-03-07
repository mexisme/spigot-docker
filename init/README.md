# docker-init

Creates a basic Docker with some useful (sane?) defaults, using various "minimum" parent images from Docker Hub: Debian, Alpine or Centos.
For my definition of "useful" of course.

This also includes some scripts inside tools/ and init/

## `init/initialise-docker-image`

Initialises the image by updating the package-index caches, and adding some default packages, e.g. `ca-certificates`, `curl` and `runit`.

## `init/create-app-user`

Creates an `app` user for use when running as a container.

_NOTE:_ It's not usually a good idea to run tools as Root, as privilege-escalations keep getting discovered, and rootless mode is still a little experimental in some contexts.

## `tools/add-*-repo`

Adds a APT or DNF repo to the internal index cache.

## `tools/install-*-packages`

Installs the given package.
It also updates the package-index cache before running, and then empties them out afterwards to conserve space in the image.

Therefore, it's a good idea to try to install all the packages in one command-line, if possible.

## `tools/errors-lib.sh`

A simple error/logging library for the other shell scripts.

## Using `runit`

This image installs `runit` (http://smarden.org/runit/) in the Alpine and Debian images, as a easily-comprehensible way to support running multiple processes within a single container.
The main reason for wanting this is to run simple "side car" processes for things like log-forwarding, process-monitoring, or background reconfiguration, when you don't have access to a orchestrator that can manage this for you (like K8s).

In order to enable this in your sub-image, you must copy one of the following sections to it, instead of an `ENTRYPOINT` or `CMD` Dockerfile command.

NOTE: With "runit", you need to tell Docker to Term with SIGHUP instead:
  https://github.com/peterbourgon/runsvinit
  https://peter.bourgon.org/blog/2015/09/24/docker-runit-and-graceful-termination.html
  https://github.com/pixers/runit-docker
  https://docs.docker.com/engine/reference/builder/#stopsignal


### Running multi-process with "runit", run as "root" user, with the various service scripts stored in /etc/services/

_NOTE:_ You'll need to use `chpst` (http://smarden.org/runit/chpst.8.html) or `su` inside your run scripts.

```
STOPSIGNAL SIGHUP
USER root
COPY ${Your Runit Configs}/ /etc/service/
# Uncomment for Debian, as it's /usr/bin:
#CMD /usr/bin/runsvdir -P /etc/service
# Uncomment for Alpine, as it's /sbin:
#CMD /sbin/runsvdir -P /etc/service
```

### Running multi-process with "runit", run as "app" user, with the various service scripts stored in /app/services/

```
STOPSIGNAL SIGHUP
ENV SVDIR=/app/service
RUN mkdir -p "$SVDIR"
COPY ${Your Runit Configs}/ "$SVDIR/"
# Uncomment for Debian, as it's /usr/bin:
CMD /usr/bin/runsvdir -P "$SVDIR"
# Uncomment for Alpine, as it's /sbin:
CMD /sbin/runsvdir -P "$SVDIR"
```

# TODO

- Add `runit` to the Centos build.
- Convert the scripts to Go, to more-easily support failures, logging, help, etc.
