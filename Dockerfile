FROM alpine:3.5
#FROM openjdk:jdk-alpine

#ENV SpigotVersion=1.11

RUN apk --update add ca-certificates wget openjdk8 git bash && \
    addgroup minecraft && adduser -D -G minecraft -h /minecraft -s /bin/bash minecraft

#VOLUME ["${PWD}/build:/minecraft"]
#VOLUME $PWD/build:/minecraft
VOLUME ["/home/wj/dev/docker/minecraft-spigot/build:/minecraft"]
USER minecraft
#RUN /bin/bash -c "cd /SPIGOT; java -jar BuildTools.jar"
RUN cd /minecraft && \
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
    java -jar BuildTools.jar
#RUN java -jar BuildTools.jar

#RUN cp /SPIGOT/spigot-${SpigotVersion}.jar ./
COPY /minecraft/spigot-*.jar ./
