# Holesail-docker

- [ ] TODO: Make README more clear.

Holesail-docker is a Docker container that proxies traffic from or to other containers.

Environment Variables

The container uses several environment variables to customize its behavior. These variables can be set when running the container using the -e flag.

## Available Environment Variables

The following environment variables are available:

- MODE: The mode in which the container should run. Can be one of client, server, or filemanager.
- PORT: The port number to use for the client or server mode.
- HOST: The hostname or IP address to use for the client or server mode.
- PUBLIC: A boolean value indicating whether the server should use a public connetor string. Only applicable in server mode.
- FORCE: A boolean value indicating whether to force a short connector string of less than 32 chars. Only applicable in server and filemanager modes.
- CONNECTOR: A connector string used to identify the connection. Can be used in client, server, and filemanager modes.
- USERNAME: The username to use for authentication in filemanager mode.
- PASSWORD: The password to use for authentication in filemanager mode.
- ROLE: The role to assign to the user in filemanager mode. Can be either admin or user.

## Setup

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
  -e PUBLIC=false \
  --network holesail \
  anaxios/holesail:latest
```

## Modes

Holesail-docker can run in three modes: Server, Client, and Filemanager.

### Server Mode

In Server mode, Holesail-docker proxies traffic from one container to another. Example `docker-compose.yml` file:

```yaml
services:
  holesail:
    container_name: holesail
    restart: unless-stopped
    image: anaxios/holesail:latest
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

In Client mode, Holesail-docker connects to a remote host. Example `docker-compose.yml` file:

```yaml
services:
  holesail:
    container_name: holesail
    restart: unless-stopped
    network_mode: "host"
    image: anaxios/holesail:latest
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
    image: anaxios/holesail:latest
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

To develop Holesail-docker, clone this repository, create docker-compose.yml and run:

```yaml
services:
  holesail:
    container_name: holesail
    restart: unless-stopped
    build: .
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

```bash
docker compose up --build
```

This will start the containers and rebuild the image if necessary.
