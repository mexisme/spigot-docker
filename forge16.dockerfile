FROM base:minecraft-downloads as mcdownloads

FROM base:java16 as download
ARG VERSION
ARG BUILD_NUM

ADD --chown=app:app https://maven.minecraftforge.net/net/minecraftforge/forge/${VERSION}-${BUILD_NUM}/forge-${VERSION}-${BUILD_NUM}-installer.jar forge-installer.jar
# ADD --chown=app:app https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar minecraft_server-1.18.1.jar
COPY --from=mcdownloads --chown=app:app minecraft_server-1.17.1.jar ./

FROM base:java16 as build
ARG VERSION

COPY --from=download --chown=app:app /app/forge-installer.jar /app/forge-installer.jar
COPY --from=download --chown=app:app /app/minecraft_server-1.17.1.jar /app/server.jar

RUN pwd; ls -la
RUN java -jar forge-installer.jar -installServer /app
# RUN java -jar forge-installer.jar -debug -installServer /app
RUN pwd; ls -la

FROM base:java16
ARG VERSION

USER root

RUN addgroup -g 10000 minecraft
RUN adduser -u 10000 -D -G minecraft -h /minecraft -s /bin/sh minecraft

RUN rmdir bin

COPY --from=build --chown=app:app /app/run.sh /app/
COPY --from=build --chown=app:app /app/user_jvm_args.txt /app/
COPY --from=build --chown=app:app /app/libraries /app/libraries
COPY --chown=app:app run-forge.sh /app/bin/run

RUN chmod +rx /app/bin/run /app/run.sh
# RUN (echo "-Xms4G"; echo "-Xmx4G"; echo "-XX:MaxPermSize=128M") >>/app/user_jvm_args.txt
RUN (echo "-Xms4G"; echo "-Xmx4G") >>/app/user_jvm_args.txt
RUN echo "eula=true" >eula.txt

USER minecraft

WORKDIR /minecraft

EXPOSE 25565

ENTRYPOINT ["bash"]
CMD [ "/app/bin/run" ]
