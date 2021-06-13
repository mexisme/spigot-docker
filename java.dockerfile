FROM base:init

USER root

RUN apk --no-cache --update upgrade && \
    apk --no-cache --update add wget openjdk11 maven git bash

ENV JAVA_HOME=/usr

USER app
