# Holesail-docker

**Warning!** Some of these features are untested.
- [ ] TODO: Make README more clear.

Holesail-docker is a Docker container that proxies traffic from or to other containers.

## Setup

---

### Create a Docker Network

Create a Docker network to connect your containers:

```bash
docker network create holesail
```

### Use the Image

Use the latest Holesail-docker image:

```bash
docker run -d --name holesail \
  -e MODE=server \
  -e PORT=25565 \
  -e HOST=minecraft \
  -e CONNECTOR=very-super-secret \
  --network holesail \
  ghcr.io/anaxios/holesail-docker:latest
```

## Modes

---

Holesail-docker can run in three modes: Server, Client, and Filemanager.

### Server Mode

In Server mode, Holesail-docker proxies traffic from one container to another. Example `docker-compose.yml` file:

```yaml
services:
  holesail:
    container_name: holesail
    restart: unless-stopped
    image: ghcr.io/anaxios/holesail-docker:latest
    environment:
      MODE: server
      PORT: 25565
      HOST: minecraft
      PUBLIC: false
      CONNECTOR: very-super-secret
    networks:
      - holesail

  mc:
    image: itzg/minecraft-server
    container_name: minecraft
    tty: true
    stdin_open: true
    restart: unless-stopped
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
    volumes:
      - ./data:/data
    depends_on:
      - holesail
    networks:
      - holesail

networks:
  holesail:
    external: true
```

### Client Mode

**Note:** Client mode is untested!

In Client mode, Holesail-docker connects to a remote host. Example `docker-compose.yml` file:

```yaml
services:
  holesail:
    container_name: holesail
    restart: unless-stopped
    network_mode: "host"
    image: ghcr.io/anaxios/holesail-docker:latest
    environment:
      MODE: client
      PORT: 8989
      HOST: 0.0.0.0
      PUBLIC: false
      CONNECTOR: very-super-secret
```

**Note:** Client mode only works on Linux, and is incompatible with Windows and Mac.

### Filemanager Mode

In Filemanager mode, Holesail-docker serves a file manager interface. Example `docker-compose.yml` file:

```yaml
services:
  holesail:
    container_name: holesail
    restart: unless-stopped
    image: ghcr.io/anaxios/holesail-docker:latest
    environment:
      MODE: filemanager
      PORT: 8989
      HOST: 0.0.0.0
      PUBLIC: true
      ROLE: user
      USERNAME: admin
      PASSWORD: admin
      CONNECTOR: very-super-secret
    volumes:
      - <host dir>:/data
```

Replace `<host dir>` with the directory you wish to share.

## Development

---

To develop Holesail-docker, clone this repository and run:

```bash
docker compose up --build
```

This will start the containers and rebuild the image if necessary.
