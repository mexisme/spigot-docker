FROM base:init

USER root

RUN apk --no-cache --update upgrade
RUN apk --no-cache --update add openjdk16 --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN apk --no-cache --update add wget maven git bash

ENV JAVA_HOME=/usr

USER app
