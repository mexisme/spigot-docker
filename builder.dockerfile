FROM base

USER root

RUN apk --no-cache --update add git make maven openjdk8

USER minecraft
