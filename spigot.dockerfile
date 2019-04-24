FROM base

COPY --chown=minecraft:minecraft ./artefacts/spigot-*.jar ./

CMD java -Xms512M -Xmx1G -XX:MaxPermSize=128M -XX:+UseConcMarkSweepGC -jar spigot-*.jar