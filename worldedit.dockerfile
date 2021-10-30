FROM base:java16 as worldedit

RUN echo 'org.gradle.jvmargs=-Xmx3G' >gradle.properties
RUN git clone https://github.com/sk89q/WorldEdit.git
RUN cd WorldEdit; cp ~/gradle.properties ./
RUN cd WorldEdit; ./gradlew --info clean setupDecompWorkspace && ./gradlew build

RUN mkdir artefacts; cp -aiv WorldEdit/worldedit-*/build/libs/*-dist.jar artefacts/

FROM gcr.io/distroless/base
ARG USER=10000

COPY --from=worldedit /app/artefacts/* /
