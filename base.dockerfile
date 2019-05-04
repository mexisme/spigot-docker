FROM alpine:3.9

RUN command addgroup minecraft && \
    adduser -D -G minecraft -h /minecraft -s /bin/bash minecraft

RUN apk --no-cache --update upgrade && \
    apk --no-cache --update add ca-certificates bash nss

USER minecraft
WORKDIR /minecraft
