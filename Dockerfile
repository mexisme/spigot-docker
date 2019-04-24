FROM alpine:3.9 as Base

RUN command addgroup minecraft && \
    adduser -D -G minecraft -h /minecraft -s /bin/bash minecraft

RUN apk --no-cache --update upgrade && \
    apk --no-cache --update add ca-certificates bash

USER minecraft
WORKDIR /minecraft

FROM Base as Builder

USER root

RUN apk --no-cache --update add git make maven openjdk8

USER minecraft
COPY --chown=minecraft:minecraft Makefile ./

RUN make spigot

FROM Base

COPY --from=Builder --chown=minecraft:minecraft /minecraft/artefacts/spigot-*.jar ./

CMD java -Xms512M -Xmx1G -XX:MaxPermSize=128M -XX:+UseConcMarkSweepGC -jar spigot-*.jar