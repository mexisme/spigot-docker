FROM base:java as build-tools

RUN git clone https://hub.spigotmc.org/stash/scm/spigot/buildtools.git
RUN cd buildtools; mvn -B -f ./pom.xml clean install

FROM base:java as spigot
ARG VERSION

COPY --from=build-tools /app/buildtools/target/BuildTools.jar ./
RUN java -jar BuildTools.jar --rev ${VERSION}

# FROM gcr.io/distroless/java
# ARG VERSION

# ARG USER=10000

FROM base:java
ARG VERSION

COPY --from=spigot /app/spigot-${VERSION}.jar /app/spigot.jar
COPY --from=spigot /app/BuildTools.log.txt /app/

USER root

RUN addgroup -g 10000 minecraft
RUN adduser -u 10000 -D -G minecraft -h /minecraft -s /bin/sh minecraft

USER minecraft

WORKDIR /minecraft

EXPOSE 25565
# The default ENTRYPOINT is ["java", "-jar"] which doesn't make it easy to add
# additional args:
ENTRYPOINT ["java"]
CMD ["-Xms2G", "-Xmx2G", "-XX:MaxPermSize=128M", "-XX:+UseConcMarkSweepGC", "-jar", "/app/spigot.jar"]
