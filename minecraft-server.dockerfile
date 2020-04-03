FROM base:init as download

ADD --chown=app:app https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar minecraft_server-1.13.2.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/4d1826eebac84847c71a77f9349cc22afd0cf0a1/server.jar minecraft_server-1.15.1.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar minecraft_server-1.15.2.jar

RUN chmod ugo+r *.jar

# FROM gcr.io/distroless/java
# ARG VERSION

# ARG USER=10000

FROM base:java
ARG VERSION

COPY --from=download --chown=app:app /app/minecraft_server-${VERSION}.jar /app/minecraft_server.jar

USER root

RUN addgroup -g 10000 minecraft
RUN adduser -u 10000 -D -G minecraft -h /minecraft -s /bin/sh minecraft

USER minecraft

WORKDIR /minecraft

EXPOSE 25565
# The default ENTRYPOINT is ["java", "-jar"] which doesn't make it easy to add
# additional args:
ENTRYPOINT ["java"]
CMD ["-Xms1G", "-Xmx1G", "-XX:MaxPermSize=128M", "-XX:+UseConcMarkSweepGC", "-jar", "/app/minecraft_server.jar", "nogui"]
