FROM node:lts-slim AS base

RUN npm i holesail -g

ENV MODE client
ENV HOST 0.0.0.0
ENV PORT 8989

EXPOSE 8989

ENTRYPOINT sh -c ' \
    if [ "$MODE" = "server" ]; then \
        holesail --live $PORT --host $HOST --connector $CONNECTOR; \
    elif [ "$MODE" = "client" ]; then \
        holesail --port $PORT --host $HOST $CONNECTOR; \
    fi '
