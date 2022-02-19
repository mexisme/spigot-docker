FROM base:minecraft-downloads as download

# FROM gcr.io/distroless/java
# ARG VERSION

# ARG USER=10000

FROM base:java16
ARG VERSION

COPY --from=download --chown=app:app /app/minecraft_server-${VERSION}.jar minecraft_server.jar

USER root

RUN addgroup -g 10000 minecraft
RUN adduser -u 10000 -D -G minecraft -h /minecraft -s /bin/sh minecraft

USER minecraft

WORKDIR /minecraft

EXPOSE 25565
# The default ENTRYPOINT is ["java", "-jar"] which doesn't make it easy to add
# additional args:
ENTRYPOINT ["java"]
CMD ["-Xms4G", "-Xmx4G", "-XX:MaxPermSize=128M", "-XX:+UseConcMarkSweepGC", "-jar", "/app/minecraft_server.jar", "nogui"]
