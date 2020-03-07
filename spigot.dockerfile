FROM base:builder as build-tools

RUN git clone https://hub.spigotmc.org/stash/scm/spigot/buildtools.git
RUN cd buildtools; mvn -B -f ./pom.xml clean install

FROM base:builder as spigot
ARG VERSION

COPY --from=build-tools /app/buildtools/target/BuildTools.jar ./
RUN java -jar BuildTools.jar --rev ${VERSION}

#FROM gcr.io/distroless/base
FROM gcr.io/distroless/java
ARG VERSION

ARG USER=10000

COPY --from=spigot /app/spigot-${VERSION}.jar /
COPY --from=spigot /app/BuildTools.log.txt /

CMD /spigot-${VERSION}.jar -Xms512M -Xmx1G -XX:MaxPermSize=128M -XX:+UseConcMarkSweepGC
