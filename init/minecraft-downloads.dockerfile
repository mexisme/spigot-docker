FROM base:init

WORKDIR /

ADD --chown=app:app https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar minecraft_server-1.13.2.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/4d1826eebac84847c71a77f9349cc22afd0cf0a1/server.jar minecraft_server-1.15.1.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar minecraft_server-1.15.2.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar minecraft_server-1.16.1.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/f02f4473dbf152c23d7d484952121db0b36698cb/server.jar minecraft_server-1.16.3.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar minecraft_server-1.16.4.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar minecraft_server-1.17.1.jar
ADD --chown=app:app https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar minecraft_server-1.18.1.jar

RUN chmod ugo+r *.jar
