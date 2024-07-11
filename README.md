Holesail-docker proxies traffic from another container.

The easiest way to do this is to create a network in Docker:
```
docker network create proxy
```

You can then use the contaier name and port of the container you want to proxy, as exampled below.

```
---
services:
  holesail:
    container_name: holesail
    restart: unless-stopped
    build: .
    environment:
      MODE: server      # defaults to client
      PORT: 25565
      HOST: minecraft   # defaults to 0.0.0.0
      CONNECTOR: very-super-secret # leave this blank to generate a random secret.
    networks:
      - proxy

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
      # attach the relative directory 'data' to the container's /data path
      - ./data:/data
    depends_on:
      - holesail
    networks:
      - proxy

networks:
  proxy:
    external: true 
```
