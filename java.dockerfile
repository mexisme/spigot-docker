FROM base:init

USER root

RUN apk --no-cache --update upgrade && \
    apk --no-cache --update add wget openjdk8 maven git bash

ENV JAVA_HOME=/usr

USER app
