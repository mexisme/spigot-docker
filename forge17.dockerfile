FROM base:java17 as download
ARG VERSION
ARG BUILD_NUM

ADD --chown=app:app https://maven.minecraftforge.net/net/minecraftforge/forge/${VERSION}-${BUILD_NUM}/forge-${VERSION}-${BUILD_NUM}-installer.jar forge-installer.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar minecraft_server-1.18.1.jar

# FROM gcr.io/distroless/java
# ARG VERSION

# ARG USER=10000

FROM base:java17 as build
ARG VERSION

COPY --from=download --chown=app:app /app/forge-installer.jar /app/forge-installer.jar
COPY --from=download --chown=app:app /app/minecraft_server-1.18.1.jar /app/server.jar

RUN pwd; ls -la
RUN java -jar forge-installer.jar -installServer
# RUN java -jar forge-installer.jar -debug -installServer
RUN pwd; ls -la

FROM base:java17
ARG VERSION

COPY --from=build --chown=app:app /app/server.jar /app/

USER root

RUN addgroup -g 10000 minecraft
RUN adduser -u 10000 -D -G minecraft -h /minecraft -s /bin/sh minecraft

USER minecraft

WORKDIR /minecraft

EXPOSE 25565
# The default ENTRYPOINT is ["java", "-jar"] which doesn't make it easy to add
# additional args:
ENTRYPOINT ["java"]
CMD ["-Xms4G", "-Xmx4G", "-XX:MaxPermSize=128M", "-jar", "/app/server.jar"]
