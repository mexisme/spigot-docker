# Minecraft in Docker

## Setup
- Install Docker and Docker Compose
- Create a `/opt/minecraft` dir, and make it owned by UID 10000, GID 10000

```bash
$ sudo bash -c 'mkdir -pv /opt/minecraft; chown -vR 10000:10000 /opt/minecraft
```

## Building

This will build a Spigot-based server:

```bash
$ make build
```

## Running

This will start the Spigot-based server, mounting the data volume on the above `/opt/minecraft` dir.

```bash
$ make spigot
```

This will start the standard server:

```bash
$ make minecraft
```

## Backup

This will backup the standard dir to `$(PWD)/BACKUP/minecraft.$(DATE).tar`:

```bash
$ make backup
```
