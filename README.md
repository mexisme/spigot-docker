Build with Packer 0.12 or later (to support the "changes" attr)

Run with:
```
docker run --tty --name=minecraft-spigot -d -p 25565:25565 -v ${LOCAL-DIR}:/minecraft minecraft-spigot:1.11.2
```

`${LOCAL-DIR}` is to persist the world-data and config files.
