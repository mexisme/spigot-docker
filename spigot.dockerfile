FROM base:builder as build-tools

RUN git clone https://hub.spigotmc.org/stash/scm/spigot/buildtools.git
RUN cd buildtools; mvn -B -f ./pom.xml clean install

FROM base:builder as spigot
ARG VERSION

COPY --from=build-tools /app/buildtools/target/BuildTools.jar ./
RUN java -jar BuildTools.jar --rev ${VERSION}

FROM gcr.io/distroless/java
ARG VERSION

ARG USER=10000

COPY --from=spigot /app/spigot-${VERSION}.jar /spigot.jar
COPY --from=spigot /app/BuildTools.log.txt /

EXPOSE 25565
WORKDIR /minecraft

# The default ENTRYPOINT is ["java", "-jar"] which doesn't make it easy to add
# additional args:
ENTRYPOINT ["java"]
CMD ["-Xms512M", "-Xmx1G", "-XX:MaxPermSize=128M", "-XX:+UseConcMarkSweepGC", "-jar", "/spigot.jar"]
