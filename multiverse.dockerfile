FROM base:java as multiverse-core

RUN git clone https://github.com/Multiverse/Multiverse-Core.git
RUN cd Multiverse-Core; git submodule update --init --recursive
RUN cd Multiverse-Core; mvn install

RUN mkdir artefacts; cp -aiv Multiverse-Core/target/*.jar artefacts/

FROM base:java as multiverse-portals

RUN git clone https://github.com/Multiverse/Multiverse-Portals.git
RUN cd Multiverse-Portals; mvn install

RUN mkdir artefacts; cp -aiv Multiverse-Portals/target/*.jar artefacts/

FROM gcr.io/distroless/base
ARG USER=10000

COPY --from=multiverse-core /app/artefacts/* /
COPY --from=multiverse-portals /app/artefacts/* /
